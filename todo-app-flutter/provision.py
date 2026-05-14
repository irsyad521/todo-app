import subprocess
import re
import os
import argparse
import shutil
import sys

ENV_FILE = "lib/core/config/env.dart"
FLUTTER_VERSION = "3.24.0"


def run(cmd):
    print(f"[>] {cmd}")
    result = subprocess.run(cmd, shell=True)
    if result.returncode != 0:
        sys.exit(1)


def get_output(cmd, timeout=None):
    return subprocess.check_output(
        cmd,
        shell=True,
        text=True,
        timeout=timeout
    ).strip()


def get_fingerprint(host):
    cmd = f"""
    echo | openssl s_client -connect {host}:443 -servername {host} -showcerts 2>/dev/null |
    awk '/BEGIN CERTIFICATE/{{i++}} i==2' |
    openssl x509 -outform der |
    sha256sum
    """
    try:
        return get_output(cmd, timeout=10).split()[0]
    except Exception:
        print("[!] Failed to get fingerprint")
        sys.exit(1)


def update_env(host, fingerprint):
    with open(ENV_FILE, "r") as f:
        content = f.read()

    content = re.sub(
        r"static const baseUrl = '.*?';",
        f"static const baseUrl = 'https://{host}/api/v1';",
        content
    )

    content = re.sub(
        r"static const host = '.*?';",
        f"static const host = '{host}';",
        content
    )

    content = re.sub(
        r"static const sslFingerprint = '.*?';",
        f"static const sslFingerprint = '{fingerprint}';",
        content
    )

    with open(ENV_FILE, "w") as f:
        f.write(content)


def detect_abi():
    try:
        abi = get_output("adb shell getprop ro.product.cpu.abi")
        print(f"[+] ABI: {abi}")

        if "arm64" in abi:
            return "arm64-v8a"
        if "armeabi" in abi:
            return "armeabi-v7a"
        if "x86_64" in abi:
            return "x86_64"
        return "arm64-v8a"
    except Exception:
        return "arm64-v8a"


def ensure_fvm():
    if shutil.which("fvm") is None:
        print("[!] fvm not found")
        sys.exit(1)

    run(f"fvm install {FLUTTER_VERSION}")
    run(f"fvm use {FLUTTER_VERSION}")


def build(build_type):
    run("fvm flutter clean")
    run("fvm flutter pub get")

    if build_type == "debug":
        run("fvm flutter build apk --debug --split-per-abi")
    else:
        run("fvm flutter build apk --release --split-per-abi")


def install(abi, build_type):
    apk = f"build/app/outputs/flutter-apk/app-{abi}-{build_type}.apk"

    if not os.path.exists(apk):
        print(f"[!] APK not found: {apk}")
        sys.exit(1)

    run(f"adb install -r {apk}")


def check_tools():
    tools = ["fvm", "adb", "openssl", "awk"]
    missing = [t for t in tools if shutil.which(t) is None]

    if missing:
        print("[!] Missing tools:", ", ".join(missing))
        sys.exit(1)

    print("[+] All required tools available")


def main():
    parser = argparse.ArgumentParser(
        description="""
Auto provisioning Flutter APK with SSL pinning (FVM)

Requirements:
  - fvm
  - adb
  - openssl
  - awk
""",
        formatter_class=argparse.RawTextHelpFormatter
    )

    parser.add_argument("domain", nargs="?", help="Target domain")
    parser.add_argument("--build", choices=["debug", "release"], default="release")
    parser.add_argument("--check", action="store_true")

    args = parser.parse_args()

    if args.check:
        check_tools()
        return

    if not args.domain:
        parser.print_help()
        sys.exit(1)

    host = args.domain
    build_type = args.build

    print(f"[+] Target: {host}")
    print(f"[+] Build: {build_type}")

    fingerprint = get_fingerprint(host)
    print(f"[+] Fingerprint: {fingerprint}")

    update_env(host, fingerprint)

    ensure_fvm()

    build(build_type)

    abi = detect_abi()

    install(abi, build_type)

    print("[✓] Done")


if __name__ == "__main__":
    main()