filter = () ->
  return (list, group_by) ->
    filtered = []
    prev_item = null
    group_changed = false
    new_field = group_by + '_CHANGED'

    angular.forEach(list, (item) ->
      group_changed = false

      if (prev_item != null)
        if (prev_item[group_by] != item[group_by])
          group_changed = true
      else
        group_changed = true

      if (group_changed)
        item[new_field] = true
      else
        item[new_field] = false

      filtered.push(item)
      prev_item = item
    )

    return filtered

app = angular.module 'yournal.filters'
app.filter 'groupby', filter