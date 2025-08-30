.PHONY: oci-build oci-push oci-pull oci-login

oci-build:
	@echo "Building OCI image..."
	@docker buildx build --platform linux/amd64 -f images/comfyui/Dockerfile -t ocr.jcan.dev/library/stable-diffusion-webui:comfyui-0.1.0 ./
oci-push:
	@echo "Pushing OCI image..."
	@docker push ocr.jcan.dev/library/stable-diffusion-webui:comfyui-0.1.0
oci-pull:
	@echo "Pulling OCI image..."
	@docker pull ocr.jcan.dev/library/stable-diffusion-webui:comfyui-0.1.0
oci-login:
	@echo "Logging into OCI registry..."
	@echo $${OCR_PASSWORD} | docker login ocr.jcan.dev -u jcan --password-stdin

.PHONY: helm-template helm-install helm-upgrade helm-uninstall
HELM_RELEASE=sd-comfyui
helm-template:
	@echo "Rendering Helm templates..."
	helm template $(HELM_RELEASE) ./helm/sd-comfyui --values ./helm/sd-comfyui/values.yaml