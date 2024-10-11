import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export type Building = { 'city' : null } |
  { 'road' : null } |
  { 'settlement' : null };
export type ResourceType = { 'ore' : null } |
  { 'wood' : null } |
  { 'wool' : null } |
  { 'grain' : null } |
  { 'brick' : null };
export interface Tile { 'resource' : [] | [ResourceType], 'value' : bigint }
export interface _SERVICE {
  'buildSettlement' : ActorMethod<[bigint, bigint, bigint], boolean>,
  'endTurn' : ActorMethod<[], undefined>,
  'getGameState' : ActorMethod<
    [],
    [] | [
      {
        'currentPlayer' : bigint,
        'players' : Array<
          {
            'id' : bigint,
            'resources' : Array<[ResourceType, bigint]>,
            'buildings' : Array<Building>,
          }
        >,
        'board' : Array<Array<Tile>>,
      }
    ]
  >,
  'initGame' : ActorMethod<[bigint], undefined>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
