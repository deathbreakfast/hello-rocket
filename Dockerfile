# Rust as the base image
FROM rust:1.74 as build

# 1. Create a new empty shell project
RUN USER=root cargo new --bin hello-rocket
WORKDIR /hello-rocket

# 2. Copy our manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# 3. Copy the source and build
RUN rm src/*.rs
COPY ./src ./src

# 4. Build for release
RUN cargo build --release

# Our final base
FROM rust:1.74

# 5. Copy the build artifact from the build stage
COPY --from=build /hello-rocket/target/release/hello-rocket .

# 6. Set environment variable and expose the port
ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=80
EXPOSE 80

# Startup command to run your binary
CMD ["./hello-rocket"]