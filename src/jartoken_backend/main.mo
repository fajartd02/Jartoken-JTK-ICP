import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";

actor Jartoken {
  var owner : Principal = Principal.fromText("igjqa-zhtmo-qhppn-eh7lt-5viq5-4e5qj-lhl7n-qd2fz-2yzx2-oczyc-tqe");
  let totalSupply : Nat = 1000000000;
  let symbol : Text = "LAMEI";

  private stable var balanceEntry : [(Principal, Nat)] = [];

  //create ledge of our token
  private var balance = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
  if (balance.size() < 1) {
    balance.put(owner, totalSupply);
  };

  //query the balance of the ledge
  public query func balanceOf(who : Principal) : async Nat {

    let getBalance : Nat = switch (balance.get(who)) {
      case null 0;
      case (?Nat) Nat;
    };

    return getBalance;
  };

  public query func getSymbol() : async Text {
    return symbol;
  };

  public shared (msg) func payOut() : async Text {
    if (balance.get(msg.caller) == null) {
      let amount : Nat = 10000;
      let result = await transferTo(msg.caller, amount);
      return result;
    } else {
      return "Already granted!";
    };
  };

  public shared (msg) func transferTo(toId : Principal, amount : Nat) : async Text {
    let ownAmount = await balanceOf(msg.caller);
    if (ownAmount > amount) {
      let leftAmount : Nat = ownAmount - amount;
      balance.put(msg.caller, leftAmount);

      let toIdAmount = await balanceOf(toId);
      let newAmount = toIdAmount + amount;
      balance.put(toId, newAmount);

      return "Success!";
    } else {
      return "Not enough funds!";
    };
  };

  system func preupgrade() {
    balanceEntry := Iter.toArray(balance.entries());
  };

  system func postupgrade() {
    balance := HashMap.fromIter<Principal, Nat>(balanceEntry.vals(), 1, Principal.equal, Principal.hash);
    if (balance.size() < 1) {
      balance.put(owner, totalSupply);
    };
  };
};
