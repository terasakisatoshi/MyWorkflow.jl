#
# Edit `Port for Communication with the Julia Process` to 9999
#

include("port.jl")
using Atom
using Atom; using Juno; Juno.connect(port)
