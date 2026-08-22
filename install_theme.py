#!/usr/bin/env python3
"""Install a WezTerm theme from this repo into the user global config."""

from __future__ import annotations

import argparse
import os
import re
import shutil
import sys
from datetime import datetime
from pathlib import Path

THEME_MARKER_RE = re.compile(r"^--\s*wezterm-config-theme:\s*(\S+)", re.MULTILINE)
REPO_ROOT = Path(__file__).resolve().parent
THEMES_DIR = REPO_ROOT / "themes"
GLOBAL_CONFIG = Path.home() / ".wezterm.lua"
DEFAULT_THEME = "ghostty-frappe"

# Optional short descriptions shown by `list`
THEME_DESCRIPTIONS = {
    "ghostty-frappe": "Ghostty-inspired Catppuccin Frappe theme (default)",
    "ghostty-frappe-pill": "Ghostty Frappe with rounded pill tabs and Hack",
    "one-dark-pro-pill": "One Dark Pro with rounded pill tabs and Hack",
    "ghostty-mocha": "Ghostty-inspired Catppuccin Mocha theme",
    "iterm2-solarized-dark": "iTerm2-inspired Solarized Dark theme",
    "tabby-darcula": "Tabby / JetBrains Darcula solid theme",
    "luna-night": "Luna-Night purple Acrylic theme",
}


def list_themes() -> list[str]:
    if not THEMES_DIR.is_dir():
        return []
    return sorted(p.stem for p in THEMES_DIR.glob("*.lua"))


def theme_path(name: str) -> Path:
    return THEMES_DIR / f"{name}.lua"


def read_marker(text: str) -> str | None:
    match = THEME_MARKER_RE.search(text)
    return match.group(1) if match else None


def cmd_list(_: argparse.Namespace) -> int:
    themes = list_themes()
    if not themes:
        print(f"No themes found in {THEMES_DIR}")
        return 1

    print("Available themes:")
    for name in themes:
        desc = THEME_DESCRIPTIONS.get(name, "")
        suffix = f"  - {desc}" if desc else ""
        print(f"  {name}{suffix}")
    return 0


def cmd_status(_: argparse.Namespace) -> int:
    if not GLOBAL_CONFIG.exists():
        print(f"Global config not found: {GLOBAL_CONFIG}")
        return 1

    is_link = GLOBAL_CONFIG.is_symlink()
    try:
        resolved = GLOBAL_CONFIG.resolve()
    except OSError:
        resolved = GLOBAL_CONFIG

    text = GLOBAL_CONFIG.read_text(encoding="utf-8", errors="replace")
    marker = read_marker(text)

    print(f"Global config: {GLOBAL_CONFIG}")
    print(f"Mode:          {'link' if is_link else 'copy/file'}")
    if is_link:
        print(f"Points to:     {resolved}")
    print(f"Theme marker:  {marker or '(none)'}")
    return 0


def backup_global() -> Path | None:
    if not GLOBAL_CONFIG.exists() and not GLOBAL_CONFIG.is_symlink():
        return None

    stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    backup = GLOBAL_CONFIG.with_name(f".wezterm.lua.bak-{stamp}")
    # Replace symlink/file with a renamed backup path
    GLOBAL_CONFIG.replace(backup)
    return backup


def install_copy(src: Path) -> None:
    shutil.copy2(src, GLOBAL_CONFIG)


def install_link(src: Path) -> None:
    try:
        os.symlink(src, GLOBAL_CONFIG)
    except OSError as exc:
        raise SystemExit(
            "Failed to create symlink. On Windows this often needs Administrator "
            "privileges or Developer Mode.\n"
            f"Detail: {exc}\n"
            "Retry with: python install_theme.py install <name> --mode copy"
        ) from exc


def cmd_install(args: argparse.Namespace) -> int:
    name = args.name
    src = theme_path(name)
    if not src.is_file():
        available = ", ".join(list_themes()) or "(none)"
        print(f"Unknown theme: {name}")
        print(f"Available: {available}")
        return 1

    if args.dry_run:
        print(f"[dry-run] would install '{name}'")
        print(f"  source: {src}")
        print(f"  target: {GLOBAL_CONFIG}")
        print(f"  mode:   {args.mode}")
        return 0

    backup = backup_global()
    if backup is not None:
        print(f"Backed up previous config to: {backup}")

    if args.mode == "link":
        install_link(src)
    else:
        install_copy(src)

    text = GLOBAL_CONFIG.read_text(encoding="utf-8", errors="replace")
    marker = read_marker(text) or name
    print(f"Installed theme '{marker}' -> {GLOBAL_CONFIG} ({args.mode})")
    print("Reload WezTerm (or open a new window) to apply.")
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Install WezTerm themes from this repository into ~/.wezterm.lua",
    )
    sub = parser.add_subparsers(dest="command", required=True)

    p_list = sub.add_parser("list", help="List available themes")
    p_list.set_defaults(func=cmd_list)

    p_status = sub.add_parser("status", help="Show current global theme")
    p_status.set_defaults(func=cmd_status)

    p_install = sub.add_parser("install", help="Install a theme by name")
    p_install.add_argument(
        "name",
        nargs="?",
        default=DEFAULT_THEME,
        help=f"Theme name (default: {DEFAULT_THEME})",
    )
    p_install.add_argument(
        "--mode",
        choices=("copy", "link"),
        default="copy",
        help="copy (default) or symlink into ~/.wezterm.lua",
    )
    p_install.add_argument(
        "--dry-run",
        action="store_true",
        help="Print what would happen without writing files",
    )
    p_install.set_defaults(func=cmd_install)

    return parser


def normalize_argv(argv: list[str]) -> list[str]:
    """Allow `python install_theme.py <theme>` as shorthand for install."""
    if not argv:
        return argv
    # Already a subcommand / help
    if argv[0] in {"list", "status", "install", "-h", "--help"}:
        return argv
    # Bare theme name (and optional install flags) -> insert `install`
    if theme_path(argv[0]).is_file():
        return ["install", *argv]
    return argv


def main(argv: list[str] | None = None) -> int:
    raw = list(sys.argv[1:] if argv is None else argv)
    parser = build_parser()
    args = parser.parse_args(normalize_argv(raw))
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
