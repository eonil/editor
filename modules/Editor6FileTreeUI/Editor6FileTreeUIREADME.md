Editor3FileTreeUI
=================
Hoon H.





Selection Snapshot Optimization
-------------------------------
There are three layers.

- Value node ID
- Pointer node ID
- Node index

First, external communication is all done in value node ID.
But, vaue node ID cannot provide quick expansion tracking in `NSOutlineView`, 
so I mapped value node ID into pointer node ID. 
And `NSOutlineView` maps pointer IDs into indices.

When you get selections from `NSOutlineView`, it provides only indices.
Which means you need to perform two layer unmappings for all node for each time
selection changes. O(n). This is not good.

Here's my solution.

- Track expansion state of all nodes.
- Snapshot them together with indices.

With the expansion states, you can rebuild pointer ID mapping from the indices.
Pointer ID to value ID unmapping is O(1), so it's ignorable.

Rebuilding is easy. 

- Perform DFS on tree nodes.
- Record all visible nodes (expanded or leaf) in an array in order.

Now you have indices to node mapping.

Here are what we archived here. 

- Selection copying cost: O(1)
- Selection resolution cost: O(n)
- You can treat copied selection as a pure value.
  No referencing involved.
  No consideration about mutation over time required.





To Do
-----
- Use `Reftable` to get strict O(1) access to ID mapping.
- Stress test.
