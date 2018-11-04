from .types import Branch, BasicBlock, Yield


def get_next_block(block, seen):
    if isinstance(block, Branch):
        return find_branch_join(block, seen)
    elif isinstance(block, (BasicBlock, Yield)):
        return block.outgoing_edge[0]
    raise NotImplementedError(block)


def find_branch_join(branch, seen=[]):
    seen.append(branch)
    curr_true_block = branch.true_edge
    while curr_true_block not in seen:
        seen.append(curr_true_block)
        curr_true_block = get_next_block(curr_true_block, seen)
    curr_false_block = branch.false_edge
    while curr_false_block not in seen:
        curr_false_block = get_next_block(curr_false_block, seen)
    return curr_false_block
    # curr_false_block = branch.false_edge
    # curr_true_block = branch.true_edge
    # while curr_false_block != curr_true_block:
    #     seen.add(curr_false_block)
    #     seen.add(curr_true_block)
    #     next_true_block = get_next_block(curr_true_block, seen)
    #     if next_true_block == curr_false_block:
    #         break
    #     next_false_block = get_next_block(curr_false_block, seen)
    #     if next_false_block == curr_true_block:
    #         break
    #     curr_true_block, curr_false_block = next_true_block, next_false_block
    # return curr_false_block
