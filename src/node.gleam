pub type Node(t) {
  BinaryNode(value: t, left: Node(t), right: Node(t))
  PartialLeftNode(value: t, left: Node(t))
  PartialRightNode(value: t, right: Node(t))
  PolyNode(value: t, children: List(Node(t)))
  Leaf(value: t)
  Empty
}
