# we want to use the rust-musl-builder:nightly image
# 1) musl is a multi system cross compiler
# 2) nightly allows us to get access to async libraries
FROM ekidd/rust-musl-builder:nightly AS build
# copy our working repo to the repo in the container
COPY . ./
# change owner of local rust to container rust
RUN sudo chown -R rust:rust .
# cargo build is the build command for rust
RUN cargo build --release

FROM scratch
COPY --from=build /home/rust/src/target/x86_64-unknown-linux-musl/release/my-cool-web-app /
ENV PORT 8181
EXPOSE ${PORT}
CMD ["/test-web-app"]