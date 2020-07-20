def rs_col_sizes(rs, rs_size)
  sizes = []
  rs_size.times do |idx|
    sizes << [
      rs.fields[idx].size,
      rs.column_values(idx).map(&:to_s).max_by(&:size).size
    ].max
  end
  sizes
end

def sql_print_header(rs, rs_size, col_sizes)
  str = ''
  rs_size.times do |idx|
    str += " #{rs.fields[idx].center(col_sizes[idx])} |"
  end
  str = str[0..-2] + "\n"
  rs_size.times do |idx|
    str += "-#{'-' * col_sizes[idx]}-+"
  end
  print str[0..-2] + "\n"
end

def sql_print_rows(rs, rs_size, col_sizes)
  rs.each_row do |row|
    row.each_with_index do |fld, idx|
      print ' '
      if fld =~ /[^0-9.\/-]/
        print fld.ljust(col_sizes[idx])
      else print fld.rjust(col_sizes[idx])
      end
      print idx == rs_size - 1 ? "\n" : ' |'
    end
  end
end

def sql_print(rs)
  rs_size = rs.fields.size
  col_sizes = rs_col_sizes(rs, rs_size)
  sql_print_header(rs, rs_size, col_sizes)
  sql_print_rows(rs, rs_size, col_sizes)
  puts "(#{rs.num_tuples} rows)"
  puts
end