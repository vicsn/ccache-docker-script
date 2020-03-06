# Hack to use CCache with Docker

If you want to more rapidly rebuild Docker images even when you changed source
code, this utility may prove to be helpful to set up and update a base `ccache`
image. Note that its currently not possible to update the base image
incrementally when multiple builds are running in parallel, you'll have to run
them serially or accept that you can't collect all updates to the ccache
directory.

**NOTE**: In most situations this is a bad idea. Test your application outside
of Docker, then build it in Docker. 

**Warning**: Do not re-use build artifacts across architectures or different
types of builds. 

# Setup

Make sure to install and set up ccache on your host machine. Then adjust your
`Dockerfile` to do the following *before* building:

1. install `ccache`
2. copy ccache files over from a ccache base image:  
    `COPY --from=ccache /ccache /ccache`
3. set ccache-specific environment variables:
    `ENV PATH "/usr/lib/ccache/bin:$PATH"`
    `ENV CCACHE_DIR "/ccache"`

# Usage

After you built your Docker image, you can extract the new `ccache` artifacts
using the script provided in this repository:

`./update-ccache.sh -i <image name> -s <source path> -d <destination path>`
