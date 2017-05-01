# Smart Factory in Swift
This project is the basis for my bachelor thesis. More infos coming soon ...

## v0.1 - completed on May 1st 2017
Basic models are implemented in order to form a factory layout that can be used to form an initial generation of factories in the next version.

### Position
* x
* y

### Product
* type (/contains a route of workstation types/)

### Field
* position
* type/state (wall, entrance, exit, *workstation*, *robot*, empty)

### Robot
* product
* position
* remainingRoute (Array of positions)
* state (starting, moving, idle, docked, finished)

### Workstation
* position
* type
* state (idle, busy)

### Factory Layout
* width
* length
* fields
