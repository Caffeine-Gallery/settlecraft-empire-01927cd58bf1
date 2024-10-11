import Bool "mo:base/Bool";

import Array "mo:base/Array";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Text "mo:base/Text";

actor {
  // Types
  type ResourceType = {
    #wood;
    #brick;
    #ore;
    #grain;
    #wool;
  };

  let ResourceTypeUtils = {
    equal = func (a: ResourceType, b: ResourceType) : Bool {
      a == b
    };
    hash = func (r: ResourceType) : Hash.Hash {
      switch (r) {
        case (#wood) 0;
        case (#brick) 1;
        case (#ore) 2;
        case (#grain) 3;
        case (#wool) 4;
      }
    };
  };

  type Building = {
    #settlement;
    #city;
    #road;
  };

  type Player = {
    id: Nat;
    resources: [(ResourceType, Nat)];
    buildings: [Building];
  };

  type Tile = {
    resource: ?ResourceType;
    value: Nat;
  };

  type GameState = {
    board: [[Tile]];
    players: [Player];
    currentPlayer: Nat;
  };

  // Stable variables
  stable var gameStateStable: ?GameState = null;

  // Helper functions
  func initializePlayer(id: Nat) : Player {
    {
      id;
      resources = [];
      buildings = [];
    }
  };

  func initializeBoard() : [[Tile]] {
    // Simplified 3x3 board for demonstration
    [
      [{ resource = ?#wood; value = 6 }, { resource = ?#brick; value = 3 }, { resource = ?#ore; value = 8 }],
      [{ resource = ?#grain; value = 5 }, { resource = null; value = 7 }, { resource = ?#wool; value = 10 }],
      [{ resource = ?#wood; value = 9 }, { resource = ?#grain; value = 4 }, { resource = ?#brick; value = 11 }]
    ]
  };

  // Game initialization
  public func initGame(numPlayers: Nat) : async () {
    let players = Array.tabulate<Player>(numPlayers, initializePlayer);
    gameStateStable := ?{
      board = initializeBoard();
      players = players;
      currentPlayer = 0;
    };
  };

  // Game actions
  public func buildSettlement(playerId: Nat, x: Nat, y: Nat) : async Bool {
    switch (gameStateStable) {
      case (null) { return false; };
      case (?state) {
        if (playerId != state.currentPlayer) { return false; };
        let player = state.players[playerId];
        // Check if player has resources (simplified)
        let woodAmount = Option.get(Array.find<(ResourceType, Nat)>(player.resources, func((r, _)) { r == #wood }), (null, 0)).1;
        let brickAmount = Option.get(Array.find<(ResourceType, Nat)>(player.resources, func((r, _)) { r == #brick }), (null, 0)).1;
        let grainAmount = Option.get(Array.find<(ResourceType, Nat)>(player.resources, func((r, _)) { r == #grain }), (null, 0)).1;
        let woolAmount = Option.get(Array.find<(ResourceType, Nat)>(player.resources, func((r, _)) { r == #wool }), (null, 0)).1;
        
        if (woodAmount >= 1 and brickAmount >= 1 and grainAmount >= 1 and woolAmount >= 1) {
          // Deduct resources (simplified)
          let updatedResources = Array.map<(ResourceType, Nat), (ResourceType, Nat)>(player.resources, func((r, amount)) {
            switch (r) {
              case (#wood) (#wood, amount - 1);
              case (#brick) (#brick, amount - 1);
              case (#grain) (#grain, amount - 1);
              case (#wool) (#wool, amount - 1);
              case (_) (r, amount);
            }
          });
          // Add settlement
          let updatedBuildings = Array.append<Building>(player.buildings, [#settlement]);
          let updatedPlayer = {
            id = player.id;
            resources = updatedResources;
            buildings = updatedBuildings;
          };
          let updatedPlayers = Array.tabulate<Player>(state.players.size(), func (i) {
            if (i == playerId) { updatedPlayer } else { state.players[i] }
          });
          gameStateStable := ?{ state with players = updatedPlayers };
          return true;
        };
        return false;
      };
    };
  };

  public func endTurn() : async () {
    switch (gameStateStable) {
      case (null) { return; };
      case (?state) {
        let nextPlayer = (state.currentPlayer + 1) % state.players.size();
        gameStateStable := ?{ state with currentPlayer = nextPlayer };
      };
    };
  };

  // Query functions
  public query func getGameState() : async ?{
    board: [[Tile]];
    players: [{id: Nat; resources: [(ResourceType, Nat)]; buildings: [Building]}];
    currentPlayer: Nat;
  } {
    gameStateStable
  };

  // System functions
  system func preupgrade() {
    // gameStateStable is already stable, no action needed
  };

  system func postupgrade() {
    // gameStateStable will be automatically restored, no action needed
  };
}
