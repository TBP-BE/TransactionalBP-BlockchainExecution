pragma solidity ^0.4.18;

contract AbstractFactory {
    address internal worklist = address(0);

    function setWorklist(address _worklist) public {
        worklist = _worklist;
    }

    function newInstance(address parent, address globalFactory) public returns(address);
    function startInstanceExecution(address processAddress) public;
}

pragma solidity ^0.4.18;

import "AbstractFactory";

contract ProcessRegistry {

    mapping (bytes32 => mapping (uint => bytes32)) private parent2ChildrenBundleId;
    mapping (bytes32 => address) private factories;

    mapping (address => bytes32) private instance2Bundle;
    address[] private instances;

    mapping (address => bytes32) private worklist2Bundle;
    address[] private worklists;

    event NewInstanceCreatedFor(address parent, address processAddress);

    function registerFactory(bytes32 bundleId, address factory) public {
        require(factories[bundleId] == address(0));
        factories[bundleId] = factory;
    }

    function registerWorklist(bytes32 bundleId, address worklist) public {
        worklist2Bundle[worklist] = bundleId;
        worklists.push(worklist);
    }

    function addChildBundleId(bytes32 parentBundleId, bytes32 processBundleId, uint nodeIndex) public {
        parent2ChildrenBundleId[parentBundleId][nodeIndex] = processBundleId;
    }

    function allInstances() public returns(address[]) {
        return instances;
    }

    function newInstanceFor(uint nodeIndex, address parent) public returns(address) {
        bytes32 parentBundleId = instance2Bundle[parent];
        bytes32 bundleId = parent2ChildrenBundleId[parentBundleId][nodeIndex];
        return newBundleInstanceFor(bundleId, parent);
    }

    function newBundleInstanceFor(bytes32 bundleId, address parent) public returns(address) {
        require(factories[bundleId] != address(0));
        var processAddress = AbstractFactory(factories[bundleId]).newInstance(parent, this);
        instance2Bundle[processAddress] = bundleId;
        instances.push(processAddress);
        AbstractFactory(factories[bundleId]).startInstanceExecution(processAddress);
        NewInstanceCreatedFor(parent, processAddress);
        return processAddress;
    }

    function childrenFor(bytes32 parent, uint nodeInd) external view returns(bytes32) {
        return parent2ChildrenBundleId[parent][nodeInd];
    }

    function bundleFor(address processInstance) public returns(bytes32) {
        return instance2Bundle[processInstance];
    }

    function worklistBundleFor(address worklist) public returns(bytes32) {
        return worklist2Bundle[worklist];
    }
}

pragma solidity ^0.4.18;

import "ProcessRegistry";


contract AbstractProcess {
    address internal owner;
    address internal parent;
    address internal worklist;
    uint internal instanceIndex;
    ProcessRegistry public processRegistry;

    function AbstractProcess(address _parent, address _worklist, address _processRegistry) public {
        owner = msg.sender;
        parent = _parent;
        worklist = _worklist;
        processRegistry = ProcessRegistry(_processRegistry);
    }

    function setInstanceIndex(uint _instanceIndex) public {
        require(msg.sender == parent);
        instanceIndex = _instanceIndex;
    }

    function handleEvent(bytes32 code, bytes32 eventType, uint _instanceIndex, bool isInstanceCompleted) public;
    function killProcess() public;
    function startExecution() public;
    function broadcastSignal() public;

    function killProcess(uint processElementIndex, uint marking, uint startedActivities) internal returns(uint, uint);
    function broadcastSignal(uint tmpMarking, uint tmpStartedActivities, uint sourceChild) internal returns(uint, uint);
    function propagateEvent(bytes32 code, bytes32 eventType, uint tmpMarking, uint tmpStartedActivities, uint sourceChild) internal returns(uint, uint) {
        if (eventType == "Error" || eventType == "Terminate")
            (tmpMarking, tmpStartedActivities) = killProcess(0, tmpMarking, tmpStartedActivities);
        else if (eventType == "Signal")
            (tmpMarking, tmpStartedActivities) = broadcastSignal(tmpMarking, tmpStartedActivities, sourceChild);
        if (parent != 0)
            AbstractProcess(parent).handleEvent(code, eventType, instanceIndex, tmpMarking | tmpStartedActivities == 0);        return (tmpMarking, tmpStartedActivities);
    }
}

pragma solidity ^0.4.18;

import "AbstractFactory";
import "AbstractProcess";

contract OrderPerPack__Factory is AbstractFactory {
    function newInstance(address parent, address processRegistry) public returns(address) {
        OrderPerPack__Contract newContract = new OrderPerPack__Contract(parent, worklist, processRegistry);
        return newContract;
    }

    function startInstanceExecution(address processAddress) public {
        OrderPerPack__Contract(processAddress).startExecution();
    }
}


contract OrderPerPack__Contract is AbstractProcess {

    uint public marking = uint(4096);
    uint public startedActivities = 0;


    // Process Variables
       //state vectors


         uint public StateVector_EOPP = 0 ;
          uint public StateVector_SCVil_ = 0 ;
          uint public StateVector_SCChe_ = 0 ;
          uint public StateVector_SCVal_ = 0 ;
          uint public StateVector_CCP_ = 0 ;
          uint public StateVector_PCC = 0 ;
          uint public StateVector_POS = 0 ;



    function OrderPerPack__Contract(address _parent, address _worklist, address _processRegistry) public AbstractProcess(_parent, _worklist, _processRegistry) {
    }

    function startExecution() public {
        require(marking == uint(4096) && StateVector_EOPP == 0);
        step(uint(4096),StateVector_EOPP |uint ((1)));
    }

    function handleEvent(bytes32 code, bytes32 eventType, uint _instanceIndex, bool isInstanceCompleted) public {
        // Process without calls to external contracts.
        // No events to catch !!!
    }

    function killProcess() public {
        (marking, startedActivities) = killProcess(0, marking, startedActivities);
    }

    function killProcess(uint processElementIndex, uint tmpMarking, uint tmpStartedActivities) internal returns(uint, uint) {
        if(processElementIndex == 0)
            tmpMarking = tmpStartedActivities = 0;
        return (tmpMarking, tmpStartedActivities);
    }

    function broadcastSignal() public {
       // var (tmpMarking, tmpStartedActivities) = broadcastSignal(marking, startedActivities, 0);
       // step(tmpMarking, tmpStartedActivities);
    }

    function broadcastSignal(uint tmpMarking, uint tmpStartedActivities, uint sourceChild) internal returns(uint, uint) {
        return (tmpMarking, tmpStartedActivities);
    }


    function EOPP_complete(uint elementIndex) external {
      var (tmpMarking, tmpStateVector) = (marking, StateVector_EOPP);
        if(elementIndex == uint(3)) {
            require(msg.sender == worklist && tmpStateVector & uint(4) != 0);
            StateVector_EOPP = terminate_task(tmpStateVector);













            step(tmpMarking | uint(2), StateVector_SCVil_ |= uint(1));

            return;
        }
    }
    function SCVil__complete(uint elementIndex) external {
      var (tmpMarking, tmpStateVector) = (marking, StateVector_SCVil_);
        if(elementIndex == uint(4)) {
            require(msg.sender == worklist && tmpStateVector & uint(4) != 0);
            StateVector_SCVil_ = terminate_task(tmpStateVector);












            step(tmpMarking | uint(32), StateVector_SCChe_ |= uint(1));

            return;
        }
    }
    function SCChe__complete(uint elementIndex) external {
      var (tmpMarking, tmpStateVector) = (marking, StateVector_SCChe_);
        if(elementIndex == uint(5)) {
            require(msg.sender == worklist && tmpStateVector & uint(4) != 0);
            StateVector_SCChe_ = terminate_task(tmpStateVector);











            step(tmpMarking | uint(64), StateVector_SCVal_ |= uint(1));

            return;
        }
    }
    function SCVal__complete(uint elementIndex) external {
      var (tmpMarking, tmpStateVector) = (marking, StateVector_SCVal_);
        if(elementIndex == uint(6)) {
            require(msg.sender == worklist && tmpStateVector & uint(4) != 0);
            StateVector_SCVal_ = terminate_task(tmpStateVector);










            step(tmpMarking | uint(128), StateVector_CCP_ |= uint(1));

            return;
        }
    }
    function CCP__complete(uint elementIndex) external {
      var (tmpMarking, tmpStateVector) = (marking, StateVector_CCP_);
        if(elementIndex == uint(8)) {
            require(msg.sender == worklist && tmpStateVector & uint(4) != 0);
            StateVector_CCP_ = terminate_task(tmpStateVector);









            step(tmpMarking | uint(512), StateVector_PCC |= uint(1));

            return;
        }
    }
    function PCC_complete(uint elementIndex) external {
      var (tmpMarking, tmpStateVector) = (marking, StateVector_PCC);
        if(elementIndex == uint(11)) {
            require(msg.sender == worklist && tmpStateVector & uint(4) != 0);
            StateVector_PCC = terminate_task(tmpStateVector);








            step(tmpMarking | uint(8192), StateVector_POS |= uint(1));

            return;
        }
    }
    function POS_complete(uint elementIndex) external {
      var (tmpMarking, tmpStateVector) = (marking, StateVector_POS);
        if(elementIndex == uint(12)) {
            require(msg.sender == worklist && tmpStateVector & uint(4) != 0);
            StateVector_POS = terminate_task(tmpStateVector);







            step(tmpMarking | uint(16384), StateVector_POS |= uint(1));

            return;
        }
    }




 function EOPPcp_complete(uint elementIndex) external {
  var (tmpMarking, tmpStateVector) = (marking, StateVector_EOPP);
    if(elementIndex == uint(13)) {
        require(msg.sender == worklist && tmpStateVector & uint (16) != 0);
       StateVector_EOPP = compensate_task(tmpStateVector);
       step(tmpMarking | uint(4096),StateVector_EOPP);
        return;
      }
 }
   function SCVil_cp_complete(uint elementIndex) external {
  var (tmpMarking, tmpStateVector) = (marking, StateVector_SCVil_);
    if(elementIndex == uint(14)) {
        require(msg.sender == worklist && tmpStateVector & uint (16) != 0);
       StateVector_SCVil_ = compensate_task(tmpStateVector);
       step(tmpMarking | uint(4),StateVector_SCVil_);
        return;
      }
 }
   function SCChe_cp_complete(uint elementIndex) external {
  var (tmpMarking, tmpStateVector) = (marking, StateVector_SCChe_);
    if(elementIndex == uint(15)) {
        require(msg.sender == worklist && tmpStateVector & uint (16) != 0);
       StateVector_SCChe_ = compensate_task(tmpStateVector);
       step(tmpMarking | uint(8),StateVector_SCChe_);
        return;
      }
 }
   function SCVal_cp_complete(uint elementIndex) external {
  var (tmpMarking, tmpStateVector) = (marking, StateVector_SCVal_);
    if(elementIndex == uint(16)) {
        require(msg.sender == worklist && tmpStateVector & uint (16) != 0);
       StateVector_SCVal_ = compensate_task(tmpStateVector);
       step(tmpMarking | uint(16),StateVector_SCVal_);
        return;
      }
 }
    function PCCcp_complete(uint elementIndex) external {
  var (tmpMarking, tmpStateVector) = (marking, StateVector_PCC);
    if(elementIndex == uint(17)) {
        require(msg.sender == worklist && tmpStateVector & uint (16) != 0);
       StateVector_PCC = compensate_task(tmpStateVector);
       step(tmpMarking | uint(1024),StateVector_PCC);
        return;
      }
 }

       function POS_fail(uint elementIndex) external {
  var (tmpMarking, tmpStateVector) = (marking, StateVector_POS);
    if(elementIndex == uint(12)) {
        require(msg.sender == worklist && tmpStateVector & uint (32) != 0);
       step(tmpMarking | uint(2048),StateVector_POS);
        return;
      }
 }



 function CCP__fail(uint elementIndex) external {
  var (tmpMarking, tmpStateVector) = (marking, StateVector_CCP_);
    if(elementIndex == uint(8)) {
        require(msg.sender == worklist && tmpStateVector & uint(4) != 0);
       StateVector_CCP_ = fail_task(tmpStateVector);
       step(tmpMarking | uint(1024  ), StateVector_CCP_);
        return;
      }
      }
     function activate_task(uint tmpStateVector) internal pure returns (uint){
        if (tmpStateVector & uint(1) != 0)
            tmpStateVector &= uint (~1);

        else
            if (tmpStateVector & uint(64) != 0)
                tmpStateVector &= uint (~64);
            tmpStateVector |= uint(4);
            return (tmpStateVector);
    }

     function terminate_task(uint tmpStateVector) internal pure returns (uint){
        if (tmpStateVector & uint(4) != 0){
            tmpStateVector &= uint(~4);
            tmpStateVector |= uint(16);
            return (tmpStateVector);
        }
    }



   function fail_task(uint tmpStateVector) internal pure returns (uint){
        if (tmpStateVector & uint(4) != 0){
            //l'activité n'est plus à l'état activé
            tmpStateVector &= uint(~4);
            tmpStateVector |= uint(64);
            return (tmpStateVector);
        }
    }

    function compensate_task(uint tmpStateVector) internal pure returns (uint){
        if (tmpStateVector & uint(16) != 0){
            //l'activité n'est plus à l'état terminé
            tmpStateVector &= uint(~16);
            tmpStateVector |= uint(32);
            return (tmpStateVector);
        }
    }
    function abort_task(uint tmpStateVector) internal pure returns (uint){
        if (tmpStateVector & uint(1) != 0){
            //l'activité n'est plus à l'état terminé
            tmpStateVector &= uint(~1);
            tmpStateVector |= uint(2);
            return (tmpStateVector);
        }
    }

    function cancel_task(uint tmpStateVector) internal pure returns (uint){
        if (tmpStateVector & uint(4) != 0){
            //l'activité n'est plus à l'état terminé
            tmpStateVector &= uint(~4);
            tmpStateVector |= uint(8);
            return (tmpStateVector);
        }
    }


    function step(uint tmpMarking, uint tmpStateVector) internal {
        uint threshold = 0;
        while (true && threshold <= 4) {
            if (tmpMarking & uint(2) == uint(2)) {
                tmpMarking = tmpMarking & uint(~2) | uint(28);
                continue;
            }
            if (tmpMarking & uint(224) == uint(224)) {
                tmpMarking = tmpMarking & uint(~224) | uint(256);
                continue;
            }

             if (tmpMarking & uint(4096) != 0 && tmpStateVector == uint(1) ) {
                 OrderPerPack__AbstractWorlist(worklist).EOPP_start(3);
                tmpMarking &= uint(~4096);
                StateVector_EOPP = activate_task(tmpStateVector);


                 continue;
            }




             if (tmpMarking & uint(4) != 0 && tmpStateVector == uint(1) ) {
                 OrderPerPack__AbstractWorlist(worklist).SCVil__start(4);
                tmpMarking &= uint(~4);
                StateVector_SCVil_ = activate_task(tmpStateVector);


                 continue;
            }




             if (tmpMarking & uint(8) != 0 && tmpStateVector == uint(1) ) {
                 OrderPerPack__AbstractWorlist(worklist).SCChe__start(5);
                tmpMarking &= uint(~8);
                StateVector_SCChe_ = activate_task(tmpStateVector);


                 continue;
            }




             if (tmpMarking & uint(16) != 0 && tmpStateVector == uint(1) ) {
                 OrderPerPack__AbstractWorlist(worklist).SCVal__start(6);
                tmpMarking &= uint(~16);
                StateVector_SCVal_ = activate_task(tmpStateVector);


                 continue;
            }



            if (tmpMarking & uint(512) != 0) {
                tmpMarking &= uint(~512);
if (SequenceFlow_00zhra9)                tmpMarking |= uint(1024);
else                 tmpMarking |= uint(2048);
                continue;
            }

             if (tmpMarking & uint(256) != 0 && tmpStateVector == uint(1) ) {
                 OrderPerPack__AbstractWorlist(worklist).CCP__start(8);
                tmpMarking &= uint(~256);
                StateVector_CCP_ = activate_task(tmpStateVector);


                 continue;
            }

               //pivot echoue
              if (tmpMarking & uint(1024) != 0 && tmpStateVector == uint(64) ) {

                     tmpMarking &= uint(~1024);













              StateVector_SCVal_= compensate_task(StateVector_SCVal_);
              OrderPerPack__AbstractWorlist(worklist).SCVal_cp_start(16);

              StateVector_SCChe_= compensate_task(StateVector_SCChe_);
              OrderPerPack__AbstractWorlist(worklist).SCChe_cp_start(15);

              StateVector_SCVil_= compensate_task(StateVector_SCVil_);
              OrderPerPack__AbstractWorlist(worklist).SCVil_cp_start(14);

              StateVector_EOPP= compensate_task(StateVector_EOPP);
              OrderPerPack__AbstractWorlist(worklist).EOPPcp_start(13);



                StateVector_PCC= abort_task(StateVector_PCC);

                StateVector_POS= abort_task(StateVector_POS);


                 continue;
            }


            if (tmpMarking & uint(8192) != 0) {
                tmpMarking &= uint(~8192);
                if (tmpMarking & uint(32766) == 0 && tmpStateVector & uint(6520) == 0) {
                   //endevent
                   (tmpMarking, tmpStateVector) = propagateEvent("PCC_Accepted", "Default", tmpMarking, tmpStateVector, uint(512));

                }
                continue;
            }


    if (tmpMarking & uint(0) != 0 && tmpStateVector == uint(0)) {
                    tmpMarking &= uint(~0);




                StateVector_PCC |= uint(1) ;


                StateVector_POS |= uint(1) ;

                continue;
            }

            if (tmpMarking & uint(16384) != 0) {
                tmpMarking &= uint(~16384);
                if (tmpMarking & uint(32766) == 0 && tmpStateVector & uint(6520) == 0) {
                   //endevent
                   (tmpMarking, tmpStateVector) = propagateEvent("POS_accepted", "Default", tmpMarking, tmpStateVector, uint(1024));

                }
                continue;
            }


    if (tmpMarking & uint(0) != 0 && tmpStateVector == uint(0)) {
                    tmpMarking &= uint(~0);



                StateVector_PCC |= uint(1) ;


                StateVector_POS |= uint(1) ;

                continue;
            }


             if (tmpMarking & uint(1024) != 0 && tmpStateVector == uint(1) ) {
                 OrderPerPack__AbstractWorlist(worklist).PCC_start(11);
                tmpMarking &= uint(~1024);
                StateVector_PCC = activate_task(tmpStateVector);


                 continue;
            }




             if (tmpMarking & uint(2048) != 0 && tmpStateVector == uint(1) ) {
                 OrderPerPack__AbstractWorlist(worklist).POS_start(12);
                tmpMarking &= uint(~2048);
                StateVector_POS = activate_task(tmpStateVector);


                 continue;
            }



               //une activité « retriable » échoue
              if (tmpMarking & uint(2048) != 0 && tmpStateVector == uint(64) ) {

            tmpMarking &= uint(~2048);
            OrderPerPack__AbstractWorlist(worklist).POS_start(12);
            StateVector_POS = activate_task(tmpStateVector);
            threshold += 1;

                 continue;
            }


            break;
        }
        if(marking != 0 ) {
            marking = tmpMarking;

        }
    }

    function getWorklistAddress() external view returns(address) {
        return worklist;
    }

    function getInstanceIndex() external view returns(uint) {
        return instanceIndex;
    }

}
pragma solidity ^0.4.18;

contract OrderPerPack__AbstractWorlist {

      function EOPP_start(uint) external;
      function SCVil__start(uint) external;
      function SCChe__start(uint) external;
      function SCVal__start(uint) external;
      function CCP__start(uint) external;
      function PCC_start(uint) external;
      function POS_start(uint) external;

          function EOPPcp_start(uint) external;
          function SCVil_cp_start(uint) external;
          function SCChe_cp_start(uint) external;
          function SCVal_cp_start(uint) external;
              function PCCcp_start(uint) external;


      function EOPP_complete(uint) external;
      function SCVil__complete(uint) external;
      function SCChe__complete(uint) external;
      function SCVal__complete(uint) external;
      function CCP__complete(uint) external;
      function PCC_complete(uint) external;
      function POS_complete(uint) external;

                          function CCP__fail(uint) external;


}

contract OrderPerPack__Worklist {

    struct Workitem {
        uint elementIndex;
        address processInstanceAddr;
    }
    Workitem[] public workitems;

    // Events with the information to include in the Log when a workitem is registered
    event EOPP_Requested(uint);
    event SCVil__Requested(uint);
    event SCChe__Requested(uint);
    event SCVal__Requested(uint);
    event CCP__Requested(uint);
    event PCC_Requested(uint);
    event POS_Requested(uint);

                        event CCP__failed(uint);

        event EOPP_compensated(uint);
        event SCVil__compensated(uint);
        event SCChe__compensated(uint);
        event SCVal__compensated(uint);
            event PCC_compensated(uint);


    function workItemsFor(uint elementIndex, address processInstance) external view returns(uint) {
        uint reqIndex = 0;
        for(uint i = 0; i < workitems.length; i++)
            if(workitems[i].elementIndex == elementIndex && workitems[i].processInstanceAddr == processInstance)
                reqIndex |= uint(1) << i;
        return reqIndex;
    }

    function processInstanceFor(uint workitemId) public returns(address) {
        require(workitemId < workitems.length);
        return workitems[workitemId].processInstanceAddr;
    }

    function elementIndexFor(uint workitemId) public returns(uint) {
        require(workitemId < workitems.length);
        return workitems[workitemId].elementIndex;
    }

    function EOPP_start(uint elementIndex) external {
    workitems.push(Workitem(elementIndex, msg.sender));
    emit EOPP_Requested(workitems.length - 1);
    }
    function SCVil__start(uint elementIndex) external {
    workitems.push(Workitem(elementIndex, msg.sender));
    emit SCVil__Requested(workitems.length - 1);
    }
    function SCChe__start(uint elementIndex) external {
    workitems.push(Workitem(elementIndex, msg.sender));
    emit SCChe__Requested(workitems.length - 1);
    }
    function SCVal__start(uint elementIndex) external {
    workitems.push(Workitem(elementIndex, msg.sender));
    emit SCVal__Requested(workitems.length - 1);
    }
    function CCP__start(uint elementIndex) external {
    workitems.push(Workitem(elementIndex, msg.sender));
    emit CCP__Requested(workitems.length - 1);
    }
    function PCC_start(uint elementIndex) external {
    workitems.push(Workitem(elementIndex, msg.sender));
    emit PCC_Requested(workitems.length - 1);
    }
    function POS_start(uint elementIndex) external {
    workitems.push(Workitem(elementIndex, msg.sender));
    emit POS_Requested(workitems.length - 1);
    }


     function EOPPcp_start(uint elementIndex) external {
    workitems.push(Workitem(elementIndex, msg.sender));
    emit EOPP_compensated(workitems.length - 1);
    }
     function SCVil_cp_start(uint elementIndex) external {
    workitems.push(Workitem(elementIndex, msg.sender));
    emit SCVil__compensated(workitems.length - 1);
    }
     function SCChe_cp_start(uint elementIndex) external {
    workitems.push(Workitem(elementIndex, msg.sender));
    emit SCChe__compensated(workitems.length - 1);
    }
     function SCVal_cp_start(uint elementIndex) external {
    workitems.push(Workitem(elementIndex, msg.sender));
    emit SCVal__compensated(workitems.length - 1);
    }
     function PCCcp_start(uint elementIndex) external {
    workitems.push(Workitem(elementIndex, msg.sender));
    emit PCC_compensated(workitems.length - 1);
    }


    function EOPP(uint workitemId) external {
        require(workitemId < workitems.length && workitems[workitemId].processInstanceAddr != address(0));
        OrderPerPack__AbstractWorlist(workitems[workitemId].processInstanceAddr).EOPP_complete(workitems[workitemId].elementIndex);
        workitems[workitemId].processInstanceAddr = address(0);
    }
    function SCVil_(uint workitemId) external {
        require(workitemId < workitems.length && workitems[workitemId].processInstanceAddr != address(0));
        OrderPerPack__AbstractWorlist(workitems[workitemId].processInstanceAddr).SCVil__complete(workitems[workitemId].elementIndex);
        workitems[workitemId].processInstanceAddr = address(0);
    }
    function SCChe_(uint workitemId) external {
        require(workitemId < workitems.length && workitems[workitemId].processInstanceAddr != address(0));
        OrderPerPack__AbstractWorlist(workitems[workitemId].processInstanceAddr).SCChe__complete(workitems[workitemId].elementIndex);
        workitems[workitemId].processInstanceAddr = address(0);
    }
    function SCVal_(uint workitemId) external {
        require(workitemId < workitems.length && workitems[workitemId].processInstanceAddr != address(0));
        OrderPerPack__AbstractWorlist(workitems[workitemId].processInstanceAddr).SCVal__complete(workitems[workitemId].elementIndex);
        workitems[workitemId].processInstanceAddr = address(0);
    }
    function CCP_(uint workitemId) external {
        require(workitemId < workitems.length && workitems[workitemId].processInstanceAddr != address(0));
        OrderPerPack__AbstractWorlist(workitems[workitemId].processInstanceAddr).CCP__complete(workitems[workitemId].elementIndex);
        workitems[workitemId].processInstanceAddr = address(0);
    }
    function PCC(uint workitemId) external {
        require(workitemId < workitems.length && workitems[workitemId].processInstanceAddr != address(0));
        OrderPerPack__AbstractWorlist(workitems[workitemId].processInstanceAddr).PCC_complete(workitems[workitemId].elementIndex);
        workitems[workitemId].processInstanceAddr = address(0);
    }
    function POS(uint workitemId) external {
        require(workitemId < workitems.length && workitems[workitemId].processInstanceAddr != address(0));
        OrderPerPack__AbstractWorlist(workitems[workitemId].processInstanceAddr).POS_complete(workitems[workitemId].elementIndex);
        workitems[workitemId].processInstanceAddr = address(0);
    }

    function EOPPcp(uint workitemId) external {
        require(workitemId < workitems.length && workitems[workitemId].processInstanceAddr != address(0));
        OrderPerPack__AbstractWorlist(workitems[workitemId].processInstanceAddr).EOPP_complete(workitems[workitemId].elementIndex);
        workitems[workitemId].processInstanceAddr = address(0);
    }
     function SCVil_cp(uint workitemId) external {
        require(workitemId < workitems.length && workitems[workitemId].processInstanceAddr != address(0));
        OrderPerPack__AbstractWorlist(workitems[workitemId].processInstanceAddr).SCVil__complete(workitems[workitemId].elementIndex);
        workitems[workitemId].processInstanceAddr = address(0);
    }
     function SCChe_cp(uint workitemId) external {
        require(workitemId < workitems.length && workitems[workitemId].processInstanceAddr != address(0));
        OrderPerPack__AbstractWorlist(workitems[workitemId].processInstanceAddr).SCChe__complete(workitems[workitemId].elementIndex);
        workitems[workitemId].processInstanceAddr = address(0);
    }
     function SCVal_cp(uint workitemId) external {
        require(workitemId < workitems.length && workitems[workitemId].processInstanceAddr != address(0));
        OrderPerPack__AbstractWorlist(workitems[workitemId].processInstanceAddr).SCVal__complete(workitems[workitemId].elementIndex);
        workitems[workitemId].processInstanceAddr = address(0);
    }
     function PCCcp(uint workitemId) external {
        require(workitemId < workitems.length && workitems[workitemId].processInstanceAddr != address(0));
        OrderPerPack__AbstractWorlist(workitems[workitemId].processInstanceAddr).PCC_complete(workitems[workitemId].elementIndex);
        workitems[workitemId].processInstanceAddr = address(0);
    }

     function CCP_fail(uint workitemId) external {
        require(workitemId < workitems.length && workitems[workitemId].processInstanceAddr != address(0));
        OrderPerPack__AbstractWorlist(workitems[workitemId].processInstanceAddr).CCP__fail(workitems[workitemId].elementIndex);
        emit CCP__failed (workitems[workitemId].elementIndex);
        workitems[workitemId].processInstanceAddr = address(0);
    }
 }
