This role has two different purposes relating to the
[flexpart](https://www.flexpart.eu/) simulation software.

The first is to install the simulation software (as a docker image and various
helper scripts) itself.

The second is to installs support for starting these simulations remotely using
an ssh login restricted to just running flexpart. This is useful when one has a
powerful server but doesn't want to allow user shell sessions.

FIXME: The following is not automated/configurable (yet). 
  * The input data used flexpart needs to be copied in by hand.
