# justfile -- Recipes for building and viewing the IBM 1130 3D model with X_eTaL and Blender

set positional-arguments

xetal_bin := "../X_eTaL-extensions/target/debug/xetal-x"
ext_dir := "../X_eTaL-extensions/extensions"
lib_dir := "../X_eTaL-extensions/extensions/blender/lib"

default:
    @just --list

# Render the 3D model, multi-angle stills, and export .glb, .blend, .obj
render:
    XETAL_PATH="{{lib_dir}}:." {{xetal_bin}} --ext {{ext_dir}} run make-ibm1130.xtl

# Open the interactive 3D Web Viewer in your browser
view:
    @if [ -f "work/ibm1130/out/index.html" ]; then \
        open work/ibm1130/out/index.html 2>/dev/null || xdg-open work/ibm1130/out/index.html; \
    else \
        echo "Run 'just render' first to generate the models and viewer."; \
    fi

# Clean generated output
clean:
    rm -rf work
