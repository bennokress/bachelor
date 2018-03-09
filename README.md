# Diversity-Aware Evolutionary Optimization of Smart Factory Layouts
[![Platform macOS](https://img.shields.io/badge/Platform-macOS-blue.svg?style=flat)](https://www.apple.com/de/macos/what-is/) [![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://swift.org/documentation/) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

This code is accompanying my Bachelor Thesis at the Ludwig-Maximilians-University of Munich. It simulates a basic Smart Factory and tries to optimize the positions of workstations in its layout. This optimization is accomplished by using methods following a basic Genetic Algorithm.

The Thesis compares the use of several diversity metrics induced in the fitness formula of the parent selection phase of the Genetic Algorithm. The use of diversity measurements itself stems from intentional unexpected changes in the environment, namely the breakdown (deactivation) of workstations in the middle of the simulation process. The hypothesis is that high diversity within the population reduces the negative effect of environmental changes to the generated solutions. Population in this setting is defined as a specified number of factory layouts.

## Installation
This project uses 	[Carthage](https://github.com/Carthage/Carthage) as a dependency manager. To run the code you have to install Carthage by following [their guide](https://github.com/Carthage/Carthage#installing-carthage). Afterwards the following commands have to be executed in the Terminal, where `PATH/TO/PROJECT/` is your actual path to the project:
```
cd PATH/TO/PROJECT/
carthage bootstrap --platform macOS
```

## How to run a customized Genetic Algorithm
This project comes equipped with a a few simulation modes to choose from:
* Development
* Test Phase 1-4
* Production

Those modes where the ones used in the process of development and as the basis of my research. Adding customized simulation modes is one of the benefits of the clear code structure in this project. To add your own mode, simply go to SimulationMode.swift and add a seventh case to the Enumeration. Building the project then will fail and Xcode will point out all the lines where the simulation parameters of your newly created mode have to be added. Make sure to fill them all according to the documentation comments above each parameter. As a last step the new simulation mode has to be selected inside SimulationSetting.swift along with the path to a folder where you want the generated statistics after each simulation.

## How to add a customized phase to the Genetic Algorithm
This project has a modularized structure of phases for the Genetic Algorithm. This structure is enforced by a protocol called `GAPhase`. Every phase has to conform to `GAPhase`, which requires a method called `execute(on generation: inout Generation)`. This method will be called each time the phase is executed and should modify the current generation (current solutions of the Genetic Algorithm). Adding a custom phase therefore only requires two steps:
1. Write a struct that implements `GAPhase`
2. Add your phase to the list of phase for your desired simulation mode. You can find this as `var phases` in SimulationMode.swift
