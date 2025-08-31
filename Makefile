.PHONY: oci-build oci-push oci-pull oci-login

_REGISTRY_URL=ocr.jcan.dev
_REGISTRY_PROJECT=library
OCI_IMAGE_NAME=sd-comfyui
# Extract the tag for this submodule from submodules.json using jq
IMAGE_TAG := $(shell jq -r '.comfyui.tag' submodules.json)

OCI_IMAGE=$(_REGISTRY_URL)/$(_REGISTRY_PROJECT)/$(OCI_IMAGE_NAME):$(IMAGE_TAG)
oci-build:
	@echo "Building OCI image: ${OCI_IMAGE}"
	@docker buildx build -D --platform linux/amd64 -f images/comfyui/Dockerfile -t ${OCI_IMAGE} ./
oci-push:
	@echo "Pushing OCI image: ${OCI_IMAGE}"
	@docker push ${OCI_IMAGE}
oci-pull:
	@echo "Pulling OCI image: ${OCI_IMAGE}"
	@docker pull ${OCI_IMAGE}
oci-login:
	@echo "Logging into OCI registry: ${_REGISTRY_URL}"
	@echo $${OCR_PASSWORD} | docker login ${_REGISTRY_URL} -u jcan --password-stdin

.PHONY: helm-template helm-install helm-upgrade helm-uninstall
HELM_RELEASE=sd-comfyui
helm-template:
	@echo "Rendering Helm templates..."
	helm template $(HELM_RELEASE) ./helm/sd-comfyui --values ./helm/sd-comfyui/values.yaml