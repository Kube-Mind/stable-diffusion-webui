import torch
import torchvision
import torchaudio
from torchvision.ops import nms
from torchaudio.models import wav2vec2_model

print(f"Torch: {torch.__version__}, CUDA: {torch.cuda.is_available()}")
print(f"Torchvision: {torchvision.__version__}")
print(f"Torchaudio: {torchaudio.__version__}")

# Torch CUDA details
if torch.cuda.is_available():
    print(f"Device: {torch.cuda.get_device_name(0)}")

# torchvision NMS test
try:
    boxes = torch.tensor([[0, 0, 10, 10], [1, 1, 11, 11]], dtype=torch.float32).cuda()
    scores = torch.tensor([0.9, 0.8], dtype=torch.float32).cuda()
    selected = nms(boxes, scores, 0.5)
    print("✅ torchvision.ops.nms is working.")
except Exception as e:
    print(f"❌ torchvision.ops.nms failed: {e}")

# torchaudio module test
try:
    print("✅ torchaudio is working.")
except Exception as e:
    print(f"❌ torchaudio model load failed: {e}")
