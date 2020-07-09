# Headless MC API

Headless MC API is a Dockerized version of Minecraft with a FabricMC mod that allows you to control it via an HTTP API.

## Setup (for developing the mod)

Get access to the repo by asking wnuke (wnuke#1010 on Discord).
Download the source code:

- `git clone git@git.wnuke.dev:wnuke/headless-fabric-mc`

If you do not have an IDE you should download one, I recommend [IntelliJ IDEA CE](https://www.jetbrains.com/idea/).

Import the project to your IDE of choice:

- `cd headless-mc-api/headless-api-mod`
- `./gradlew genSources`
- `./gradlew openIdea` for IntelliJ IDEA
- `./gradlew eclipse` for Eclipse

## Setup (for building the Docker image)

Get access to the repo by asking wnuke (wnuke#1010 on Discord).
Download the source code:

- `git clone git@git.wnuke.dev:wnuke/headless-fabric-mc`
- `git submodule update`

Install Docker ([here](https://www.docker.com/products/docker-desktop) for Desktop users).
Then run the following commands to build the image:

- `cd headless-mc-api`
- `docker build .`

## License

This project is available under the GNU GPLv3. Please read the [license file](/LICENSE) for more information.
