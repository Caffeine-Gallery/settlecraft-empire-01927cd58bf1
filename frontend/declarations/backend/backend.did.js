export const idlFactory = ({ IDL }) => {
  const ResourceType = IDL.Variant({
    'ore' : IDL.Null,
    'wood' : IDL.Null,
    'wool' : IDL.Null,
    'grain' : IDL.Null,
    'brick' : IDL.Null,
  });
  const Building = IDL.Variant({
    'city' : IDL.Null,
    'road' : IDL.Null,
    'settlement' : IDL.Null,
  });
  const Tile = IDL.Record({
    'resource' : IDL.Opt(ResourceType),
    'value' : IDL.Nat,
  });
  return IDL.Service({
    'buildSettlement' : IDL.Func([IDL.Nat, IDL.Nat, IDL.Nat], [IDL.Bool], []),
    'endTurn' : IDL.Func([], [], []),
    'getGameState' : IDL.Func(
        [],
        [
          IDL.Opt(
            IDL.Record({
              'currentPlayer' : IDL.Nat,
              'players' : IDL.Vec(
                IDL.Record({
                  'id' : IDL.Nat,
                  'resources' : IDL.Vec(IDL.Tuple(ResourceType, IDL.Nat)),
                  'buildings' : IDL.Vec(Building),
                })
              ),
              'board' : IDL.Vec(IDL.Vec(Tile)),
            })
          ),
        ],
        ['query'],
      ),
    'initGame' : IDL.Func([IDL.Nat], [], []),
  });
};
export const init = ({ IDL }) => { return []; };
