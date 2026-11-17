# LocalMind

**Run AI models locally. Keep your data on your machine.**

LocalMind is a lightweight, cross-platform launcher for running local AI models using interchangeable inference runtimes.

It is designed to make local AI inference straightforward without tying the project to a specific model, model provider, or runtime.

[English](README.md) | [فارسی](README.fa.md)

---

## Features

- Run different local AI models.
- Support for GGUF models.
- Windows and Linux support.
- GPU acceleration when supported by the selected runtime and hardware.
- CPU-only inference.
- Configurable model and runtime.
- Local API server.
- OpenAI-compatible API when supported by the runtime.
- No cloud account or API key required.

## Project Structure

```text
LocalMind/
├── runtime/
│   ├── windows/
│   │   └── llamafile.exe
│   └── linux/
│       └── llamafile
├── models/
│   └── model.gguf
├── run.bat
├── run.sh
├── README.md
└── README.fa.md
```

## Requirements

- Windows or Linux.
- A compatible inference runtime.
- A supported model file.
- Optional GPU with a compatible driver and runtime backend.

**Important:** This repository does not include model files or runtime binaries. You must download them separately and place them in the directories shown above.

## 1. Download an Inference Runtime

This project currently uses [llamafile](https://github.com/Mozilla-Ocho/llamafile) as its example runtime.

**Download:** [llamafile Releases](https://github.com/mozilla-ai/llamafile/releases/tag/0.10.6)

Download the executable for your operating system:

- **Windows:** Download the Windows executable and place it at `runtime/windows/llamafile.exe`.
- **Linux:** Download the Linux executable and place it at `runtime/linux/llamafile`.

You only need the executable for your operating system.

The runtime is replaceable. Other compatible runtimes can be integrated in the future.

## 2. Download a Model

LocalMind is not limited to a particular model. You can use any model format supported by your selected runtime.

### Example: Qwen3.8-2B

For the initial setup, you can use:

- Model: [Qwen3.8-2B-Distill-GGUF](https://huggingface.co/empero-ai/Qwen3.8-2B-Distill-GGUF)
- Example quantization: `Qwen3.8-2B-Q6_K.gguf`

[Download Qwen3.8-2B-Q6_K.gguf](https://huggingface.co/empero-ai/Qwen3.8-2B-Distill-GGUF/resolve/main/Qwen3.8-2B-Q6_K.gguf?download=true)

After downloading, rename the file to:

```text
model.gguf
```

Then place it inside:

```text
models/model.gguf
```

You can replace this file with another compatible model whenever you want.

**Model compatibility depends on the inference runtime and its version.** For example, some newer model architectures require newer llama.cpp builds. Always check the selected model's requirements before choosing a runtime version.

## 3. Run LocalMind

### Windows

Double-click:

```text
run.bat
```

Or run it from the terminal:

```powershell
.\run.bat
```

### Linux

Make the launcher executable:

```bash
chmod +x run.sh
```

Run it:

```bash
./run.sh
```

## 4. Access the Local API

When the server starts successfully, it will be available at:

```text
http://127.0.0.1:8080
```

For runtimes that provide an OpenAI-compatible API, the chat completion endpoint is typically:

```text
http://127.0.0.1:8080/v1/chat/completions
```

Example request:

```bash
curl http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "local-model",
    "messages": [
      {
        "role": "user",
        "content": "Hello! Introduce yourself."
      }
    ],
    "temperature": 0.7
  }'
```

The exact API behavior depends on the selected runtime.

## GPU and CPU Execution

LocalMind is designed to support both GPU-accelerated and CPU-only inference.

The example llamafile launcher uses automatic GPU backend selection:

```bash
--gpu auto -ngl 999
```

This requests automatic backend selection and GPU layer offloading. Actual GPU usage depends on the runtime build, available backend, drivers, and hardware.

To explicitly use CPU-only inference, use:

```bash
--gpu disable -ngl 0
```

Automatic GPU selection should not be treated as a guarantee of seamless CPU fallback if GPU initialization fails.

## Configuration

The launcher scripts use the following default settings:

| Setting    | Default             |
| ---------- | ------------------- |
| Runtime    | llamafile           |
| Model      | `models/model.gguf` |
| Host       | `127.0.0.1`         |
| Port       | `8080`              |
| GPU mode   | `auto`              |
| GPU layers | `999`               |

You can modify these values in `run.bat` or `run.sh`.

## Security

By default, the server listens on `127.0.0.1`, making it accessible only from the local machine.

Do not expose the server to a public network without implementing appropriate authentication and access controls.

## Roadmap

- [ ] Support additional inference runtimes.
- [ ] Automatic hardware and GPU detection.
- [ ] Runtime configuration.
- [ ] Model selection.
- [ ] Model download management.
- [ ] Context and inference configuration.
- [ ] Cross-platform improvements.
- [ ] Simple graphical interface.
- [ ] OpenAI-compatible API integration across supported runtimes.

## Contributing

Contributions, bug reports, and suggestions are welcome.

If you want to add support for another runtime or model format, feel free to open an issue or submit a pull request.

## License

See the [LICENSE](LICENSE) file for licensing information.
