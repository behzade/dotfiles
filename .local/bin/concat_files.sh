#!/bin/bash
#
# A script to recursively find, filter, and concatenate file content
# from a target directory directly to the system clipboard for LLM context.
# Now with fully flexible argument ordering.
#

# --- Variables & Initial Setup ---
declare -a IGNORE_DIRS=()
declare -a IGNORE_PATTERNS=()
declare -a POSITIONAL_ARGS=()

# --- Functions ---
usage() {
    echo "Usage: $0 [OPTIONS] <directory> <ext1> [ext2]..."
    echo "  Gathers content from a directory and copies it to the system clipboard."
    echo
    echo "Arguments:"
    echo "  <directory>       The target directory to scan."
    echo "  <ext1> [ext2]...  One or more file extensions to include."
    echo
    echo "Options:"
    echo "  -i <dir>          Directory to ignore (e.g., -i .git -i node_modules)."
    echo "  -p <pattern>      Filename pattern to ignore (e.g., -p '*_test.lua')."
    echo
    echo "Example:"
    echo "  $0 . lua"
    echo "  # Gathers all .lua files from the current directory and subdirectories."
    exit 1
}

# Determines the correct clipboard command based on the OS.
get_clipboard_cmd() {
    case "$(uname -s)" in
        Darwin) echo 'pbcopy' ;;
        Linux)
            if command -v wl-copy &> /dev/null; then
                echo 'wl-copy'
            elif command -v xclip &> /dev/null; then
                echo 'xclip -selection clipboard'
            else
                echo ""
            fi
            ;;
        *) echo "" ;;
    esac
}

# --- Pre-flight Check ---
CLIPBOARD_CMD=$(get_clipboard_cmd)
if [ -z "$CLIPBOARD_CMD" ]; then
    echo "Error: Clipboard utility not found." >&2
    echo "Please install 'pbcopy' (macOS), 'wl-copy' (Wayland), or 'xclip' (X11)." >&2
    exit 1
fi

# --- Manual Argument Parsing Loop ---
# This loop processes all arguments, allowing flags to be mixed with positional args.
while [[ $# -gt 0 ]]; do
    case "$1" in
        -i)
            if [ -z "$2" ]; then echo "Error: Flag '-i' requires a directory argument." >&2; usage; fi
            IGNORE_DIRS+=("$2")
            shift 2 # Move past flag and its value
            ;;
        -p)
            if [ -z "$2" ]; then echo "Error: Flag '-p' requires a pattern argument." >&2; usage; fi
            IGNORE_PATTERNS+=("$2")
            shift 2 # Move past flag and its value
            ;;
        -h|--help)
            usage
            ;;
        -*)
            echo "Error: Unknown option '$1'" >&2
            usage
            ;;
        *)
            # Assume it's a positional argument (directory or extension)
            POSITIONAL_ARGS+=("$1")
            shift 1 # Move past argument
            ;;
    esac
done

# --- Positional Argument Validation ---
# We need at least a directory and one extension.
if [ ${#POSITIONAL_ARGS[@]} -lt 2 ]; then
    echo "Error: Missing target directory or file extension." >&2
    usage
fi

TARGET_DIR="${POSITIONAL_ARGS[0]}"
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' not found." >&2
    exit 1
fi

# All remaining positional arguments are extensions.
EXTENSIONS=("${POSITIONAL_ARGS[@]:1}")

# --- Main Logic ---
# Change to the target directory to simplify all subsequent paths.
cd "$TARGET_DIR" || exit 1

# --- Build the 'find' command dynamically ---
declare -a find_args=(".")
declare -a prune_conditions=()

# Group all ignore conditions together.
for dir in "${IGNORE_DIRS[@]}"; do
    prune_conditions+=(-o -path "./${dir}")
done
for pattern in "${IGNORE_PATTERNS[@]}"; do
    prune_conditions+=(-o -name "${pattern}")
done

# If there are ignore conditions, add them to the find command as a pruned group.
if [ ${#prune_conditions[@]} -gt 0 ]; then
    # The first element is the leading '-o', which we remove.
    find_args+=(\( "${prune_conditions[@]:1}" \))
    find_args+=(-prune -o)
fi

# Build the main search condition for file extensions.
find_args+=(\()
for i in "${!EXTENSIONS[@]}"; do
    find_args+=(-name "*.${EXTENSIONS[i]}")
    if [ "$i" -lt $((${#EXTENSIONS[@]} - 1)) ]; then
        find_args+=(-o)
    fi
done
find_args+=(\))

# Finalize with file type and safe printing.
find_args+=(-type f -print0)

# --- File Processing ---
TEMP_OUTPUT=$(mktemp)
trap 'rm -f "$TEMP_OUTPUT"' EXIT # Ensure the temporary file is always removed.

echo "Gathering context from '${TARGET_DIR}'..."

FILES_FOUND=0
while IFS= read -r -d $'\0' filepath; do
    ((FILES_FOUND++))
    echo " -> Adding: ${filepath}"
    {
        echo "--- FILE: ${filepath} ---"
        cat "${filepath}"
        echo
    } >> "$TEMP_OUTPUT"
done < <(find "${find_args[@]}")

# --- Final Output ---
if [ "$FILES_FOUND" -eq 0 ]; then
    echo "Warning: No matching files were found. Clipboard is unchanged."
    exit 0
fi

cat "$TEMP_OUTPUT" | $CLIPBOARD_CMD

echo "-----------------------------------------------------"
echo "Success! Copied content of ${FILES_FOUND} files to the clipboard."

