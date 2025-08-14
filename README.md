# Gno Workshop

Welcome to the **Gno Workshop** repository! This is designed to help you learn Gno by providing a series of exercises that cover various aspects of Gno development.

## Getting Started

### Step 1: Fork the Repository

First, [fork this repository](https://github.com/aeddi/gno-workshop/fork), allowing you to push your progress to your own copy.

### Step 2: Set Up Your Development Environment

The preconfigured [devcontainer](https://containers.dev/) in this repository provides a convenient way to set up your development environment in no time. It includes all the necessary tools and configurations to start working on Gno exercises.

You can use the devcontainer in two ways: in the cloud or locally.

#### GitHub Codespaces

Launch a fully-featured cloud-based IDE in one click using **GitHub Codespaces**:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/aeddi/gno-workshop)

#### Visual Studio Code

You can also run the devcontainer locally using **Visual Studio Code** and **Docker** by following these steps:

1. Install and configure [Docker](https://www.docker.com/get-started/) on your machine.
2. Install [Visual Studio Code](https://code.visualstudio.com/).
3. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for Visual Studio Code.
4. Clone your forked repository to your local machine and open it in Visual Studio Code.
5. When prompted, click on `Reopen in Container` to start building the devcontainer or open the command palette (_Ctrl+Shift+P_ or _Cmd+Shift+P_) and select `Dev Containers: Reopen in Container`.
6. Wait for the container to be ready to start. This may take a few minutes on the first run.

### Step 3: Start Developing

Once the devcontainer is set up, you can start working on the exercises by opening the `Gnodev` panel. You can do this in two ways:

- Click on the `Gnodev` icon in the top right corner of Visual Studio Code.
- Or open the command palette (_Ctrl+Shift+P_ or _Cmd+Shift+P_) and type `Gno: Start Gnodev Server`.

Happy coding!

## Local Setup (without devcontainer)

If you prefer to set up the your development environment locally without using the devcontainer, you will need to install the following prerequisites:

- **make** to run commands defined in the Makefile.
- **Go 1.23+** to compile Gno tools.

Then, follow these steps:

1. Clone the repository to your local machine and navigate to the project directory:

```sh
git clone https://github.com/<your_username>/gno-workshop.git
cd gno-workshop
```

2. Install the Gno tools:

```sh
make install_tools
```

3. Optionally, you can install and configure the Gno LSP server for your editor, see [gnoverse/gnopls](https://github.com/gnoverse/gnopls) for more details.
4. Start the Gno development server by running:

```sh
make dev
```

5. Open your web browser and navigate to [http://localhost:8888](http://localhost:8888) to access the Gno web interface and browse the exercises.

The Makefile contains various commands to help you with development, such as `make test` to run tests or `make lint` to lint your Gno code. Use `make help` to see a list of available commands.
