import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";

actor Jartoken {
  var owner : Principal = Principal.fromText("igjqa-zhtmo-qhppn-eh7lt-5viq5-4e5qj-lhl7n-qd2fz-2yzx2-oczyc-tqe");
  var totalSupply : Nat = 1000000000;
  var symbol : Text = "JTK"; // jartoken

  var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
  balances.put(owner, totalSupply);

  public query func balanceOf(who : Principal) : async Nat {
    let balance : Nat = switch (balances.get(who)) {
      case null 0;
      case (?res) res;
    };

    return balance;
  };

  public query func getSymbol() : async Text {
    return symbol;
  };
};
