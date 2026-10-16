# Assembly-Programs
# COAL Assembly Assignments

A collection of 16-bit x86 Assembly Language programs written for the COAL (Computer Organization & Assembly Language) course, assembled with NASM and run on DOSBox.

## Description

This repository contains solutions to various COAL course assignments, covering topics such as:

- Video memory manipulation and text-mode display output
- Subroutines, stack frames, and calling conventions
- String primitives (`MOVSB`, `CMPSB`, `SCASB`, `STOSB`)
- Bounded viewport rendering, windowed scrolling, and keyword highlighting
- Numeric output and status bar formatting

Each assignment lives in its own folder (e.g. `Assignment3/`) with its `.asm` source file.

## Tools Used

- **NASM** — assembler
- **DOSBox** — 16-bit x86 emulator for running the code
- **Notepad++** — editor with the COAL package plugin for assembling, rendering, and debugging

## Setup — Assembly Programming Package

The easiest way to assemble, run, and debug these programs is using the preconfigured **Assembly Programming Package**, which bundles NASM, DOSBox, and a Notepad++ setup with hotkeys.

**Package:** https://github.com/ASD0x41/Assembly-Programming-Package

### 1. Download

- Go to the link above.
- Download the latest release as a **ZIP** (or clone the repo).
- Extract it anywhere on your machine (e.g. `C:\AssemblyProgrammingPackage`).

### 2. Open Notepad++

- Launch `code` (notepad++) from the extracted folder.
- The package ships with the required plugins already configured.

### 3. Load a program

- Open any `.asm` file from this repository in Notepad++.

### 4. Assemble and run

Inside Notepad++, use the built-in hotkeys:

| Hotkey | Action |
|--------|--------|
| **Alt + R** | Assemble and **run** the program (renders output in DOSBox) |
| **Alt + D** | Assemble and launch the **debugger** (step through execution) |

The plugin assembles the `.asm` with NASM, launches DOSBox automatically, and executes the resulting binary — no manual `nasm` or `mount` commands needed.

### 5. Editing and re-running

- Edit the `.asm` file.
- Save.
- Hit **Alt + R** again to reassemble and rerun.

## Folder Structure

```
.
├── README.md
├── Assignment1/
│   └── assignment1.asm
├── Assignment2/
│   └── assignment2.asm
├── Assignment3/
│   └── org 100h.asm
└── ...
```

## Notes

- All programs are written for **16-bit real mode** (`org 0x100`), producing `.com` files.
- Display memory is accessed at segment `0xB800` in text mode.
- Stack cleanup is done with `ret n`; all subroutines use `bp`-relative addressing and preserve caller registers.
