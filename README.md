# TransactionalBP-BlockchainExecution

The present project is an extension to an existing tool named Caterpillar in order to support the execution of Transactional Business Processes.
We extended specifically the version 2.0 of Caterpillar where you can find the original source code at: https://github.com/orlenyslp/Caterpillar/tree/master/v2.0. 
We mainly brought modifications to the core of Caterpillar, here named TBP-BE-core.
The execution-panel which serves as user interface to interact with the core is the same.

For installing and using the core and the execution-panel, please follow instructions at: https://github.com/orlenyslp/Caterpillar

## Failure handling
Following a task failure and depending on the activity's transactional properties, the Solidity code generation templates (bpmn2sol.ejs and worklist2sol.ejs) produce the code of the corresponding functions.
For example, when a pivot activity fails, a function called ActivityName_fail() is generated. This function: 
(i) updates the state vector of the current task to failed; (ii) updates the value of the marking variable; and 
(iii) calls the step function to execute the actions to take. The latter are:\
1.compensate the set of activities situated between the current and the precedent pivot (each activity between two pivots or before the first pivot must be compensatable);\
2.start the next alternative;\
3.else abort activities that are at the state initial when no alternative exists after the previous pivot.\
You can see motivating_scenario.sol which corresponds to the smart contracts generated for the motivating scenario orderPerPackage.png.
        
