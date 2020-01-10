#
# Edit `Port for Communication with the Julia Process` to 9999
#
using Atom
using Juno; Juno.connect("host.docker.internal", 9999)
