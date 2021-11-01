# Build images using docker buildx

## Setup QEMU

You might want to update image prior to running below. Remember to run upon restart of system.

```
docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
```

Check with `cat /proc/sys/fs/binfmt_misc/qemu-aarch64`


## Setup builder
```
docker buildx create --name arm-builder
docker buildx use arm-builder
docker buildx inspect --bootstrap
```

## Build image and push it

### Custom hugo-extended image
```
docker buildx build --platform linux/amd64,linux/arm64 -t sircas/hugo-extended:0.84.3 . --push 
```
