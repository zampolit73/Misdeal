#!/usr/bin/env python3
"""D373: derive two 16-second location beds from verified Creative Commons recordings.

Run with the repository root as cwd. Never alter courtyard.
Requires ffmpeg (standard Ubuntu GitHub Actions image). Source links and CC BY
attribution are in docs/D373_RECORDED_AUDIO_SOURCES.md.
"""
from __future__ import annotations

import array
import hashlib
import math
import os
import pathlib
import shutil
import subprocess
import tempfile
import urllib.request
import wave

SAMPLE_RATE = 16000
DURATION = 16
ROOT = pathlib.Path(__file__).resolve().parents[2]
TARGET = ROOT / "assets/audio/ambience"

SOURCE_URLS = {
    "castle_door": "https://opengameart.org/sites/default/files/creakylightwoodendoor.wav",
    "ossuary_bones": "https://opengameart.org/sites/default/files/bones-2.wav",
    "ossuary_drips": "https://opengameart.org/sites/default/files/amb_waterdrip_1.flac",
}
LICENSE_PAGES = {
    "castle_door": "https://opengameart.org/content/creaky-light-wooden-door",
    "ossuary_bones": "https://opengameart.org/content/bones-2",
    "ossuary_drips": "https://opengameart.org/content/ambient-water-drips",
}


def download(name: str, url: str, folder: pathlib.Path) -> pathlib.Path:
    filename = folder / (name + pathlib.Path(url).suffix)
    req = urllib.request.Request(url, headers={"User-Agent": "Misdeal-D373-CC-licensed-sound-import/1.0"})
    with urllib.request.urlopen(req, timeout=45) as response:
        if response.status != 200:
            raise RuntimeError(f"Source {name}: HTTP {response.status}")
        # Cap size and reject HTML / error pages masquerading as audio.
        data = response.read(12_000_000)
    if not (data.startswith(b"RIFF") or data.startswith(b"fLaC") or data.startswith(b"OggS")):
        raise RuntimeError(f"Source {name}: invalid audio magic, starts with {data[:12]!r}")
    if len(data) >= 12_000_000:
        raise RuntimeError(f"Source {name}: source exceeded size cap")
    filename.write_bytes(data)
    print(f"SOURCE {name} bytes={len(data)} sha256={hashlib.sha256(data).hexdigest()} license={LICENSE_PAGES[name]}")
    return filename


def decode(source: pathlib.Path) -> list[float]:
    ffmpeg = os.environ.get("FFMPEG_EXE") or shutil.which("ffmpeg")
    if not ffmpeg:
        raise RuntimeError("ffmpeg required to decode licensed recordings")
    result = subprocess.run(
        [ffmpeg, "-hide_banner", "-loglevel", "error", "-nostdin",
         "-i", str(source), "-vn", "-ac", "1", "-ar", str(SAMPLE_RATE),
         "-f", "s16le", "-acodec", "pcm_s16le", "-"],
        check=True, capture_output=True,
    )
    pcm = array.array("h")
    pcm.frombytes(result.stdout)
    if not pcm:
        raise RuntimeError(f"No PCM decoded for {source.name}")
    if __import__("sys").byteorder != "little":
        pcm.byteswap()
    out = [float(v) / 32768 for v in pcm]
    # No noise generation; gain-only acoustic material, preserving original sound texture.
    peak = max(abs(v) for v in out)
    if peak < 0.002:
        raise RuntimeError(f"{source} suspiciously silent, peak={peak}")
    gain = min(18.0, .77 / peak)
    return [v * gain for v in out]


def extract(samples: list[float], begin: float, length: float) -> list[float]:
    start = max(0, round(begin * SAMPLE_RATE))
    end = min(len(samples), start + round(length * SAMPLE_RATE))
    if end <= start:
        raise RuntimeError("Invalid source excerpt")
    return samples[start:end]


def place(out: list[float], segment: list[float], at: float, gain: float) -> None:
    base = round(at * SAMPLE_RATE)
    limit = min(len(segment), len(out) - base)
    fade = min(round(.06 * SAMPLE_RATE), max(1, limit // 4))
    for i in range(limit):
        # Fade avoids clicks without turning recordings into broadband noise.
        ramp = min(1.0, i / fade, (limit - i - 1) / fade)
        if ramp > 0.0:
            out[base + i] += segment[i] * gain * ramp


def soft_echo(out: list[float], taps: list[tuple[float, float]]) -> None:
    dry = out.copy()
    for seconds, scale in taps:
        shift = round(seconds * SAMPLE_RATE)
        for i in range(shift, len(out)):
            out[i] += dry[i-shift] * scale


def save(name: str, floats: list[float]) -> None:
    samples = array.array("h")
    peak = max(abs(v) for v in floats)
    overall = min(1.0, .80 / peak) if peak else 1.0
    for x in floats:
        samples.append(max(-32768, min(32767, round(x * overall * 32767))))
    if __import__("sys").byteorder != "little":
        samples.byteswap()
    destination = TARGET / f"d369_{name}_roomtone.wav"
    with wave.open(str(destination), "wb") as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(SAMPLE_RATE)
        wav.writeframes(samples.tobytes())
    data = destination.read_bytes()
    if len(data) != 512044:
        raise RuntimeError(f"Expected exactly 512044 bytes, got {len(data)}")
    # Long quiet interval must be distinguishable from an actual recorded event.
    first = math.sqrt(sum(v*v for v in floats[:SAMPLE_RATE]) / SAMPLE_RATE)
    loudest = max(math.sqrt(sum(v*v for v in floats[k:k+SAMPLE_RATE]) / SAMPLE_RATE)
                  for k in range(0, len(floats), SAMPLE_RATE))
    if first > .015 or loudest < .025:
        raise RuntimeError(f"Mix dynamics insufficient for {name}: quiet={first:.4f}, max={loudest:.4f}")
    print(f"OUTPUT {destination} bytes={len(data)} sha256={hashlib.sha256(data).hexdigest()} peak={peak:.4f} quiet={first:.4f} active={loudest:.4f}")


def main() -> None:
    TARGET.mkdir(parents=True, exist_ok=True)
    courtyard = TARGET / "d369_courtyard_roomtone.wav"
    courtyard_sha = hashlib.sha256(courtyard.read_bytes()).hexdigest()
    with tempfile.TemporaryDirectory(prefix="misdeal-d373-") as tmpdir:
        tmp = pathlib.Path(tmpdir)
        recordings = {name: decode(download(name, url, tmp)) for name, url in SOURCE_URLS.items()}

    door = recordings["castle_door"]
    bone = recordings["ossuary_bones"]
    drip = recordings["ossuary_drips"]
    print(f"recording lengths: door={len(door)/SAMPLE_RATE:.2f}s; bone={len(bone)/SAMPLE_RATE:.2f}s; drip={len(drip)/SAMPLE_RATE:.2f}s")

    castle = [0.0] * (SAMPLE_RATE * DURATION)
    door_clip = extract(door, .0, 4.7)
    place(castle, door_clip, 2.05, .72)
    # A second quieter creak from a different portion; no generic synth underneath.
    place(castle, extract(door, min(.35, len(door)/SAMPLE_RATE/5), 3.8), 10.25, .38)
    soft_echo(castle, [(.115, .10), (.305, .055)])
    save("castle", castle)

    ossuary = [0.0] * (SAMPLE_RATE * DURATION)
    bone_clip = extract(bone, 0.0, 1.55)
    drip_clip = extract(drip, 0.0, 2.3)
    place(ossuary, bone_clip, 2.15, .70)
    place(ossuary, drip_clip, 4.6, .54)
    place(ossuary, bone_clip, 9.55, .43)
    place(ossuary, drip_clip, 12.50, .43)
    soft_echo(ossuary, [(.18, .17), (.46, .07)])
    save("ossuary", ossuary)

    # Preserve the user's only partly accepted prior cue unmodified.
    if hashlib.sha256(courtyard.read_bytes()).hexdigest() != courtyard_sha:
        raise RuntimeError("Approved baseline courtyard must not be modified")
    print(f"COURTYARD_UNCHANGED sha256={courtyard_sha}")


if __name__ == "__main__":
    main()
