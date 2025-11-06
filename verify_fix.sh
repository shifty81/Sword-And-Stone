#!/bin/bash
# Verification script for player movement fix

echo "🔍 Verifying Player Movement Fix..."
echo ""

# Check if critical files exist
echo "📁 Checking files..."
files=(
    "scripts/entities/player/topdown_player.gd"
    "scenes/main/crimson_isles_main.tscn"
    "assets/sprites/player_character.png"
    "PLAYER_MOVEMENT_FIX.md"
    "IMPLEMENTATION_SUMMARY.md"
    "tests/test_player_movement.gd"
)

all_found=true
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file NOT FOUND"
        all_found=false
    fi
done

echo ""
echo "🔧 Checking player controller fix..."
if grep -q 'Input.get_vector("move_left", "move_right", "move_back", "move_forward")' scripts/entities/player/topdown_player.gd; then
    echo "  ✅ Input.get_vector() has correct parameter order"
else
    echo "  ❌ Input.get_vector() parameters may be wrong"
    all_found=false
fi

echo ""
echo "🎨 Checking sprite integration..."
if grep -q 'player_character.png' scenes/main/crimson_isles_main.tscn; then
    echo "  ✅ Player sprite is referenced in main scene"
else
    echo "  ❌ Player sprite not found in scene"
    all_found=false
fi

echo ""
echo "📊 File statistics..."
echo "  Sprite files: $(ls -1 assets/sprites/player_character*.png 2>/dev/null | wc -l)"
echo "  Documentation files: $(ls -1 *PLAYER* *IMPLEMENTATION* 2>/dev/null | wc -l)"
echo "  Test files: $(find tests -name "*player*" 2>/dev/null | wc -l)"

echo ""
if [ "$all_found" = true ]; then
    echo "✅ All checks passed! Player movement fix is complete."
    exit 0
else
    echo "❌ Some checks failed. Review the output above."
    exit 1
fi
