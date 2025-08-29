.PHONY: oci-build oci-push oci-pull oci-login

oci-build:
	@echo "Building OCI image..."
	@docker buildx build --platform linux/amd64 -f images/comfyui/Dockerfile -t ocr.jcan.dev/library/stable-diffusion-webui:comfyui-0.1.0 ./