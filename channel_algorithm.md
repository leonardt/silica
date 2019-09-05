For each `path` between yields
    `conds` = collect all condition values for branches on `path`
    `channels_pushed` = collect all channels that are pushed along `path`
    `channels_popped` = collect all channels that are popped along `path`
    `code_for_path` =  rest of code along path without channel actions
    emit
        if `conds`:
            for c in channels_popped:
                <c>_ready = 1 
            for c in channels_pushed:
                <c>_valid = 1 
            while ~(reduce(&, <c>_valid for c in channels_popped) &
                    reduce(&, <c>_ready for c in channels_pushed)):
                yield
            `code_for_path`
            yield
