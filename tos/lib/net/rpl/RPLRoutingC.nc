/* Top-level component to wire together the RPL layers */

configuration RPLRoutingC {
  provides {
    interface StdControl;
    interface RootControl;
  }
} implementation {
  components RPLRankC;
  components RPLRoutingEngineC;
  components RPLDAORoutingEngineC;

  /* we receive routing messages through the ICMP component, which
     recieves all packets with the ICMP  */
  components IPStackC;
  components new ICMPCodeDispatchC(ICMP_TYPE_ROUTER_ADV) as ICMP_RA;

  StdControl = RPLRoutingEngineC;
  StdControl = RPLRankC;
  StdControl = RPLDAORoutingEngineC;
  RootControl = RPLRoutingEngineC;

  RPLRankC.ICMP_RA -> ICMP_RA;
  RPLDAORoutingEngineC.ICMP_RA -> ICMP_RA;
  IPStackC.RoutingControl -> RPLRoutingEngineC.StdControl;
  IPStackC.RoutingControl -> RPLDAORoutingEngineC.StdControl;

}
