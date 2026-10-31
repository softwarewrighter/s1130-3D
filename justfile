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

# Open the interactive 3D Web Viewer in your browser.
# Start `just serve` first, or use `just view-serve` to do both.
view:
    @if [ -f "work/ibm1130/out/index.html" ]; then \
        if command -v open >/dev/null 2>&1; then \
            open http://127.0.0.1:5823/ >/dev/null 2>&1 || true; \
        elif command -v xdg-open >/dev/null 2>&1; then \
            xdg-open http://127.0.0.1:5823/ >/dev/null 2>&1 || true; \
        fi; \
        echo "Viewer: http://127.0.0.1:5823/ (run 'just serve' in another terminal if it is not already running)"; \
    else \
        echo "Run 'just render' first to generate the models and viewer."; \
    fi

# Serve the generated viewer over HTTP. Keep this terminal open while viewing.
serve:
    @if [ -f "work/ibm1130/out/index.html" ]; then \
        python3 -m http.server 5823 --directory work/ibm1130/out; \
    else \
        echo "Run 'just render' first to generate the models and viewer."; \
    fi

# Serve the viewer and open it in the browser. Press Ctrl-C to stop serving.
view-serve:
    @if [ -f "work/ibm1130/out/index.html" ]; then \
        (sleep 1; if command -v open >/dev/null 2>&1; then open http://127.0.0.1:5823/; elif command -v xdg-open >/dev/null 2>&1; then xdg-open http://127.0.0.1:5823/; fi) >/dev/null 2>&1 & \
        python3 -m http.server 5823 --directory work/ibm1130/out; \
    else \
        echo "Run 'just render' first to generate the models and viewer."; \
    fi

# Clean generated output
clean:
    rm -rf work
