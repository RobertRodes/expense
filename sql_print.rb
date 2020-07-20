def rs_col_widths(rs, rs_size)
  widths = []
  rs_size.times do |idx|
    widths << [
      rs.fields[idx].size,
      rs.column_values(idx).max_by(&:size).size
    ].max
  end
  widths
end

def sql_print_header(rs, rs_size, col_widths)
  str = ''
  rs_size.times do |idx|
    str += " #{rs.fields[idx].center(col_widths[idx])} |"
  end
  str = str[0..-2] + "\n"
  rs_size.times do |idx|
    str += "-#{'-' * col_widths[idx]}-+"
  end
  print str[0..-2] + "\n"
end

def sql_print_rows(rs, rs_size, col_widths)
  rs.each_row do |row|
    row.each_with_index do |fld, idx|
      print ' '
      if fld =~ /[^0-9.\/-]/
        print fld.ljust(col_widths[idx])
      else print fld.rjust(col_widths[idx])
      end
      print idx == rs_size - 1 ? "\n" : ' |'
    end
  end
end

def sql_print(rs)
  rs_size = rs.fields.size
  col_widths = rs_col_widths(rs, rs_size)
  sql_print_header(rs, rs_size, col_widths)
  sql_print_rows(rs, rs_size, col_widths)
  puts "(#{rs.num_tuples} rows)"
  puts
end