#! /usr/bin/ruby

require 'rubygems'
require 'webrick'
require 'yaml'

################################################################################
# Copyright (C) 2021 Jeffery S. Koppe
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <http://www.gnu.org/licenses/>
################################################################################




##################################################################
# SavedQueries
#
#
##################################################################
class SavedReports
attr_accessor :reports

  def initialize()

    @reports = Hash.new

    if File.file?("application_reports.yml")
      #read the yaml file into the collection
      self.reports = YAML.load(File.read("application_reports.yml"))
    else
      puts "yaml file does not exist!!!"
      puts"saving new empty reports yaml file"
      self.save()
    end

  end #initialize




  def add(report)
    #add or update the item in the collection@items
   @reports[report.report_name] = report
   self.save()
#      puts "UPDATED ITEM"

  end #add




  #delete a report (note id is numeric, not a string.
  def delete(report_name)
   gone = @reports.delete(report_name.to_s)
   self.save()
#   puts "deleted item #{gone}"
  end #delete





  #save the yaml file to disk, application_reports.yml is default, other file names can be passed in
  def save(file_name='application_reports.yml')
   #open output file, write the yaml, close the file
   f = File.open(file_name, "w")
   f.write(@reports.to_yaml)
   f.close
  end #save



end #SavedReports



##################################################################
# Report
#
#
##################################################################
class Report < Hash

attr_accessor :report_name,
  :id_order,            :id_filter,            :id_exact,               :id_sort,
  :name_order,          :name_filter,          :name_exact,             :name_sort,
  :description_order,   :description_filter,   :description_exact,      :description_sort,
  :location_order,      :location_filter,      :location_exact,         :location_sort,
  :genre_order,         :genre_filter,         :genre_exact,            :genre_sort,
  :tags_order,          :tags_filter,          :tags_exact,             :tags_sort,
  :cost_order,          :cost_filter,          :cost_exact,             :cost_sort,
  :value_order,         :value_filter,         :value_exact,            :value_sort,
  :acquired_order,      :acquired_filter,      :acquired_exact,         :acquired_sort,
  :added_order,         :added_filter,         :added_exact,            :added_sort,
  :image_dir_order,     :image_dir_filter,     :image_dir_exact,        :image_dir_sort,
  :icon_image_order,    :icon_image_filter,    :icon_image_exact,       :icon_image_sort,
  :item_image_order,    :item_image_filter,    :item_image_exact,       :item_image_sort,
  :web_order,           :web_filter,           :web_exact,              :web_sort,
  :notes_order,         :notes_filter,         :notes_exact,            :notes_sort,

  :base_size_order,     :base_size_filter,     :base_size_exact,        :base_size_sort,
  :category_order,      :category_filter,      :category_exact,         :category_sort,
  :completed_order,     :completed_filter,     :completed_exact,        :completed_sort,
  :manufacturer_order,  :manufacturer_filter,  :manufacturer_exact,     :manufacturer_sort,
  :material_order,      :material_filter,      :material_exact,         :material_sort,
  :number_bases_order,  :number_bases_filter,  :number_bases_exact,     :number_bases_sort,
  :painter_order,       :painter_filter,       :painter_exact,          :painter_sort,
  :quantity_order,      :quantity_filter,      :quantity_exact,         :quantity_sort,
  :rule_system_order,   :rule_system_filter,   :rule_system_exact,      :rule_system_sort,
  :scale_order,         :scale_filter,         :scale_exact,            :scale_sort,
  :status_order,        :status_filter,        :status_exact,           :status_sort,
  :type_order,          :type_filter,          :type_exact,             :type_sort,

  :query_name,          :report_format,        :exclude_html_format,    :exclude_summary


  def initialize(
    report_name = nil,
    id_order = nil,            id_filter = nil,            id_exact = nil,               id_sort = nil,
    name_order = nil,          name_filter = nil,          name_exact = nil,             name_sort = nil,
    description_order = nil,   description_filter = nil,   description_exact = nil,      description_sort = nil,
    location_order = nil,      location_filter = nil,      location_exact = nil,         location_sort = nil,
    genre_order = nil,         genre_filter = nil,         genre_exact = nil,            genre_sort = nil,
    tags_order = nil,          tags_filter = nil,          tags_exact = nil,             tags_sort = nil,
    cost_order = nil,          cost_filter = nil,          cost_exact = nil,             cost_sort = nil,
    value_order = nil,         value_filter = nil,         value_exact = nil,            value_sort = nil,
    acquired_order = nil,      acquired_filter = nil,      acquired_exact = nil,         acquired_sort = nil,
    added_order = nil,         added_filter = nil,         added_exact = nil,            added_sort = nil,
    image_dir_order = nil,     image_dir_filter = nil,     image_dir_exact = nil,        image_dir_sort = nil,
    icon_image_order = nil,    icon_image_filter = nil,    icon_image_exact = nil,       icon_image_sort = nil,
    item_image_order = nil,    item_image_filter = nil,    item_image_exact = nil,       item_image_sort = nil,
    web_order = nil,           web_filter = nil,           web_exact = nil,              web_sort = nil,
    notes_order = nil,         notes_filter = nil,         notes_exact = nil,            notes_sort = nil,

    base_size_order = nil,     base_size_filter = nil,     base_size_exact = nil,        base_size_sort = nil,
    category_order = nil,      category_filter = nil,      category_exact = nil,         category_sort = nil,
    completed_order = nil,     completed_filter = nil,     completed_exact = nil,        completed_sort = nil,
    manufacturer_order = nil,  manufacturer_filter = nil,  manufacturer_exact = nil,     manufacturer_sort = nil,
    material_order = nil,      material_filter = nil,      material_exact = nil,         material_sort = nil,
    number_bases_order = nil,  number_bases_filter = nil,  number_bases_exact = nil,     number_bases_sort = nil,
    painter_order = nil,       painter_filter = nil,       painter_exact = nil,          painter_sort = nil,
    quantity_order = nil,      quantity_filter = nil,      quantity_exact = nil,         quantity_sort = nil,
    rule_system_order = nil,   rule_system_filter = nil,   rule_system_exact = nil,      rule_system_sort = nil,
    scale_order = nil,         scale_filter = nil,         scale_exact = nil,            scale_sort = nil,
    status_order = nil,        status_filter = nil,        status_exact = nil,           status_sort = nil,
    type_order = nil,          type_filter = nil,          type_exact = nil,             type_sort = nil,

    query_name = nil,          report_format = nil,        exclude_html_format = nil,    exclude_summary = nil)

    #autofill the instance variables with method added to Object class, below
    set_instance_variables(binding, *local_variables)

  end #initialize

end #Report Class





##################################################################
#Query Results`
#Query
#
##################################################################
class QueryResults < WEBrick::HTTPServlet::AbstractServlet

  #prepare class for either get or post requests
  def do_GET(request, response)
    status, content_type, body = query_results(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def do_POST(request, response)
    status, content_type, body = query_results(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def save_report(query)

    #create a new empty report using the name of the query to name the report object
    report = Report.new(query['query_name'].to_s)

    #loop through the empty report fields assigning the equivalent query values
    report.instance_variables.each {|attribute|
      #need to remove the '@' from the instance variable name to match the query field name
      field = attribute.to_s
      field.gsub!(/@/,'')
      #assign the query field value to the report field
      report.instance_variable_set(attribute, "#{query[field]}")
    }

    #query doesn't have a 'report_name' field so we need to assign that manually to equal the query name
    report.report_name = query['query_name'].to_s

    #add the newly created report to the saved reports (overwrites reports with the same name in case there have been changes)
    $saved_reports.add(report)

    #save the saved reports yaml file
    $saved_reports.save()

  end #def save_report




  def query_results(request)

    #check and save the query parameters for later recall if a query name has been provided
    if request.query['query_name'] &&              #save/update report if named
       request.query['query_name'].to_s != ''      #unless report named ''
      save_report(request.query)
    end #if query name

    #subset of $collection
    subset = {}
    #sort the results by these fields
    sort_fields = Array.new()
    #flag to determine queried state (no other way?)
    queried = ''
    summary_field_name = ''

    #Save the report options for use later in formatting the query Results
    report_type = request.query['report_type']

    if report_type == 'standard' then
      report_format = ''
      exclude_summary = request.query['exclude_summary']
    elsif report_type == 'labels' then
      report_format = report_type
      #exclude_summary = ''
    elsif report_type == 'tab_delimited' then
      exclude_html_format = report_type
      exclude_summary = 'ON'
    elsif report_type == 'bulk_update' then
      bulk_update = report_type
      exclude_summary = request.query['exclude_summary']
    elsif report_type.match(/pie|bar|bar-stacked|bar-grouped|timeline/) then
      chart = 'ON'
      chart_qty = 'ON'
      exclude_summary = 'ON'
    end

    #Delete the options from the actual item query since items don't have corresponding fields
    request.query.delete('report_type')
    request.query.delete('exclude_summary')

    select_by = Array.new() #to pass to report for summary

    #we need a hash of hashes for all the available fields to see if they are going
    #to be included in the final report and, if so, in what manner
    #some (most) of these will be removed if not specified in the report
    query = Hash.new()
    request.query.each_key {|key|
      key.match(/^(.+)_.+$/)
      name = $1
      query[name] = Hash.new()
    }

    #next, populate the query[field] subhashes, this tells us how the field is being used in the query
    request.query.each_key {|key|

#     #is the field to be selected and if so, in what position (order) in the report
      if key.match(/_order$/) && request.query[key].to_i > 0 then
        key.match(/^(.+)_order$/)
        query[$1]['name'] = $1
        query[$1]['order'] =  request.query[key]
        if query[$1]['order'].to_i == 1 then
          summary_field_name = query[$1]['name'] #yes, we have a #1 field which means we want to summarize things.
        end #sort the results by the first ordered field
      end #if

      #is the field to be used to filter the results?
      if key.match(/_filter$/) && request.query[key].to_s != '' then
        key.match(/^(.+)_filter$/)
        query[$1]['name'] = $1
        query[$1]['value'] =  request.query[key]
#        puts "QUERY KEY VALUE: #{request.query[key]}"

        #find the scope of the select
        scope = nil
        field = "#{$1}_exact"
        if request.query[field].to_s != '' then scope = 'exact' end
        queried = 'YES' #I hate this but we need to know if the data has been queried later on to determine if no selection criteria have been selected

        ############################################
        # this is where the query parameters can be checked to see if we are doing a boolean search (and/or)
        # need to determine how to remove records from the subset if the query value contains '+' and the first characters
        # otherwise subset.merge! can be used to append records with the second filter value
        #puts "CHECKING FOR SLICE OR MERGE"
        $query_field = query[$1]['name']
        request.query[key].to_s.match(/^(~*)(.+)/)
        $or_filter, $query_value = $1, $2
        #puts "#{$query_field} contains #{request.query[key].to_s} :::"
        if request.query[key].to_s.match(/^~.+/) or subset.count < 1 then
          # values that start with '~' are requesting an 'OR' operation
          if subset.count > 0 then
            select_by << "OR "
          else
              puts "FIRST SELECT"
          end
          select_by << "#{$query_field}=#{$query_value}"
          puts "QUERY: #{$query_field}=#{$query_value}"
          subset.merge!($collection.select($query_field, $query_value, scope.to_s))
          puts "MERGING"
        else #default to an 'AND' operand
          intersect = {}                                                               #create a new subset containing the next filter value
          intersect = $collection.select($query_field, $query_value, scope.to_s) #find the records with that filter value_exact
          #remove records from subset if they are not also in intersect
          $keys_to_remove = subset.keys - intersect.keys #find the keys that are not in both sets
          $keys_to_remove.each { |k| subset.delete k } #remove the key/value pairs from subset
          puts "INTERSECTING"
          select_by << "AND #{$query_field}=#{$query_value}"
        end # matching on plus
          ##################################################
          #add matching records to subset
          #        subset.merge!($collection.select($1.to_s, request.query[key].to_s, scope.to_s))
      end #if

      #finally, are we sorting by this field?
      if key.match(/_sort$/) && request.query[key].to_s != '' then
        key.match(/^(.+)_sort$/)
        sort_fields[query[$1]['order'].to_i] = $1
      end #if
    } #end each query key

    #remove fields that are not requested in the query. After this query[] will contain only fields requested for the report
    query.each_key {|field|
      if query[field]['order'].to_s != '' || query[field]['value'].to_s != '' || query[field]['sort'].to_s != '' then
#        puts "keeping #{field}"
      else
        query.delete(field)
      end
    } #end each field

    #if no records have been selected because the data has not been queried (e.g., no select parameters have been provided), select them all
    if subset.empty? && queried.empty? then
      subset = $collection.select('','','')
    end

    #default sort to the first column if nothing else is selected
    if sort_fields.length == 0 then
      sort_fields[0] = summary_field_name
    end
    subset_ids = []
    subset_ids = $collection.sort(subset, sort_fields)
    ##### At this point subset_ids now contains ids of all records that fit the search criteria all in the correct sort order

    ###########################################################################
    #CHART QUERY RESULTS
    #puts "***************************CHART:  #{chart}*******************************"

    if chart then

      #sort the ids so the detail listing matches chart
      if report_type != 'timeline' then
        subset_ids = $collection.sort(subset, sort_fields)
      else
        subset_ids = $collection.sort(subset, ['acquired','completed'])
        subset_ids.reverse!
      end
      #call and return the chart
      return 200, "text/html", Chart.display(subset_ids, query, report_type, chart_qty)
    end #if bulk_update
    #END BULK UPDATES
    ##############################################################################

    ##### Time to format the report
    format_results(subset_ids, query, sort_fields, select_by, report_format, request.query['query_name'].to_s, exclude_summary, exclude_html_format, bulk_update, chart)

end # query_results


def format_results(subset_ids, query, sort_fields=nil, select_by=nil, report_format=nil, report_name=nil, exclude_summary=nil, exclude_html_format=nil, bulk_update=nil, chart=nil)

  #method variables
  report_html  = String.new
  report       = Array.new()
  row_count    = 0

  if select_by != nil then select_by.reject! { |f| f.nil? || f.match(/^\s+$/) } end #clean out empty members
  if select_by != nil then select_by[0] = "Filter by: #{select_by[0]}" end

  if sort_fields != nil then sort_fields.reject! { |f| f.nil? || f.match(/^\s+$/) } end #clean out empty members
  if sort_fields != nil then sort_fields[0] = "Sorted by: #{sort_fields[0]}" end

  #loop through the subset ids to create the individual report item rows
  subset_ids.each { | id |
    report_row = Array.new()

    #put the item id as the first element of the rows
    report_row[0] = id

    # now loop through each field of the requested query, add it to the query response
    position = 0
    query.each {|field_name, field|
      #start/continue assembling the row
      if field['order'] != nil then
        #put the field in the row array using the index to ensure the user selected order is represented in the report
        report_row[field['order'].to_i] =  $collection.items[id].instance_eval(field_name)
     end
    } #end query.each

    report[row_count] = report_row
    row_count += 1
  } #do subset_id



  #create the header row. This is put first (in the report_html) and after each summary row
  header_row = Array.new()
  query.each {|key, field|
#      #adjust user selected order to zero based to use as array indices
      if field['order'] != nil then
        position = field['order'].to_i - 1
        header_row[position] = key
      end
  }

  #special formatting for monetary values
  value_format = header_row.find_index("value")
  cost_format = header_row.find_index("cost")

  #turning id into a link
  id_format = header_row.find_index("id")

  #image handling (show the image, not the image name)
  image_format = header_row.find_index("item_image")

  #icon handling (show the icon, not the icon name)
  icon_format = header_row.find_index("icon_image")

  #web address handling (show web as link not bare address)
  web_format = header_row.find_index("web")


  summary_field_name = header_row[0]
  current_summary_value = String.new()
  report_row_formatted = String.new()

  #summary running totals
  summary_count = 0
  summary_replacement_cost  = 0
  summary_replacement_value = 0
  summary_genre             = ''
  summary_quantity          = 0
  summary_number_bases      = 0


  #report totals
  total_count               = 0
  total_replacement_cost    = 0
  total_replacement_value   = 0
  total_quantity            = 0
  total_number_bases        = 0

  #if bulk update is being used we need an extra header column heading
  bulk_update_header = ''
  if bulk_update != nil && bulk_update != '' then
    bulk_update_header = "<th>update</th>"
  end

#loop through each report row and format it. Add summary rows as necessary
report.each do |row|

  item_key = row.shift(1).join('')

  #insert a summary row if the value in the first column has changed
  if row[0].to_s != current_summary_value && current_summary_value.to_s != '' then

    if exclude_summary == nil then
      report_row_formatted << field_summary(summary_count, summary_field_name, current_summary_value, summary_replacement_cost, summary_replacement_value, summary_quantity, summary_number_bases, summary_genre, report_format)
      report_row_formatted << %Q~<tr>#{bulk_update_header}<th>#{header_row.join('</th><th>')}</th></tr>~
    end

    #update the report totals
    total_count               = total_count             + summary_count
    total_replacement_cost    = total_replacement_cost  + summary_replacement_cost
    total_replacement_value   = total_replacement_value + summary_replacement_value
    total_quantity            = total_quantity          + summary_quantity
    total_number_bases        = total_number_bases      + summary_number_bases
    #reset the summary running totals
    summary_count             = 0
    summary_replacement_cost  = 0
    summary_replacement_value = 0
    summary_quantity          = 0
    summary_number_bases      = 0

    summary_genre             = ''
    summary_tags              = ''
  end

  #apply the formatting for monetary values (e.g., show 23.50 rather than 23.5)
  if cost_format != nil && row[cost_format].to_s != '' && row[cost_format] != 0 then
    row[cost_format] = format("%.2f", row[cost_format].to_f)
  end
  if value_format != nil && row[value_format].to_s != '' && row[value_format] != 0 then
    row[value_format] = format("%.2f", row[value_format].to_f)
  end

  #if id is present in report format it as a link to edit the item
  if id_format != nil && row[id_format].to_s != '' && row[id_format] != 0 then
    row[id_format] = %Q~<a href="#{$SERVER}:#{$PORT}/manage_item?id=#{row[id_format]}" target="_blank">#{row[id_format]}</a>~
  end

  #if item_image is present in report format it as a image, not the item_image name
  if image_format != nil && row[image_format].to_s != '' && row[image_format] != 0 then
    formatted_pictures = String.new()
    row[image_format].split(',').each do |picture|
           formatted_pictures << %Q~<img src="#{$SERVER}:#{$PORT}/application_images/#{picture}" alt=#{picture} /> ~
    end
    row[image_format] = formatted_pictures
  end

  #if icon_image is present in report format it as a image, not the icon_image name
  if icon_format != nil && row[icon_format].to_s != '' && row[icon_format] != 0 then
    row[icon_format] = %Q~<img style="height:100px;width:75px;" src="#{$SERVER}:#{$PORT}/application_images/#{row[icon_format]}" />~
  end

  #if web is present in report format it as a link, not the bare url
  if web_format != nil && row[web_format].to_s != '' && row[web_format] != 0 then
    if row[web_format].match(/^http/) then
      row[web_format] = %Q~<a href="#{row[web_format]}" target="_blank" >#{row[web_format]}</a>~
    else
      row[web_format] = %Q~<a href="#{$SERVER}:#{$PORT}/#{row[web_format]}" target="_blank" >#{row[web_format]}</a>~
    end
  end

  #if bulk_update we need to add a select box
  bulk_select = ''
  if bulk_update != nil then
    bulk_select = %Q~<td><input type='checkbox' id='#{item_key.to_i}' name='#{item_key.to_i}' value='#{item_key.to_i}' checked='checked'></td>~
  end


  #add the next item to the report
  report_row_formatted << %Q~<tr>#{bulk_select}<td>#{row.join('</td><td>')}</td></tr>\n~
  #store the current summary column value to see if it changes next item and therefore needing a summary row
  current_summary_value = row[0]
  #update the running totals
  summary_count += 1
  summary_replacement_cost  = summary_replacement_cost  + $collection.items[item_key.to_i].cost.to_f
  summary_replacement_value = summary_replacement_value + $collection.items[item_key.to_i].value.to_f
  summary_quantity          = summary_quantity          + $collection.items[item_key.to_i].quantity.to_i
  summary_number_bases      = summary_number_bases      + $collection.items[item_key.to_i].number_bases.to_i

  #used in creating drawer labels
  summary_genre  << %Q~<b>#{$collection.items[item_key.to_i].genre}~
  if $collection.items[item_key.to_i].tags != '' then
    summary_genre << %Q~:</b> #{$collection.items[item_key.to_i].tags.gsub(',', ' -')},~
  else summary_genre << "</b>,"
  end
#  summary_genre  << $collection.items[item_key.to_i].tags

end #each row



  #append the last location summary row to report
  if exclude_summary == nil then
    report_row_formatted << field_summary(summary_count, summary_field_name, current_summary_value, summary_replacement_cost, summary_replacement_value, summary_quantity, summary_number_bases, summary_genre, report_format)
  end
    #update the report totals
    total_count               = total_count             + summary_count
    total_replacement_cost    = total_replacement_cost  + summary_replacement_cost
    total_replacement_value   = total_replacement_value + summary_replacement_value
    total_quantity            = total_quantity          + summary_quantity
    total_number_bases        = total_number_bases      + summary_number_bases

#return a text only report if requested so... remove html code
if exclude_html_format then
    report_row_formatted.gsub! /[\n|\r]/, ", "
    report_row_formatted.gsub! '<thead[^>]*>',''
    report_row_formatted.gsub! '</thead>',''
    report_row_formatted.gsub! '<tfoot[^>]*>',''
    report_row_formatted.gsub! '</tfoot>',''
    report_row_formatted.gsub! '</tr>,',"\n"
    report_row_formatted.gsub! '<tr[^>]*>',''
    report_row_formatted.gsub! '</td><td>',"\t"
    report_row_formatted.gsub! '<td[^>]*>',''
    report_row_formatted.gsub! '</td>',''
    report_row_formatted.gsub! '</a>',''
    report_row_formatted.gsub! /<a href[^>]*>/, ''
    report_row_formatted.gsub! /<img[^>]*>/, "\t"

  return 200, "text", "#{header_row.join("\t")}\n#{report_row_formatted}"
end

###########################################################################
#BULK UPDATES FORM AS QUERY RESULTS
if bulk_update then
  return 200, "text/html", BulkUpdate.form(header_row, report_row_formatted)
end #if bulk_update
#END BULK UPDATES
##############################################################################


   #prepend the report heading, wrap the whole report in html tags
  report_html << %Q~<!DOCTYPE html><html lang="en">
  <head><title>#{$APPLICATION_NAME} Report - #{report_name}</title>
    <link rel="stylesheet" type="text/css" href="../application_styles/report.css" />
    <link rel="stylesheet" type="text/css" href="../sortable_table/sortable-table.css" />
    <link rel="stylesheet" href="../sortable/sortable-theme-minimal.css" />
    <script src='../sortable/sortable.js'></script>
  </head><body>
   <div style="width:100%;">
   <h1 style="width:100%;text-align:center;">#{report_name}</h1>
   <h2 style="width:100%;text-align:center;">Date: #{Time.now.strftime("%d %b %Y | Time: %l:%M %P")}</h2>

    <table style="width:40%;margin:auto;font-weight:bold;">
      <tr>
        <td>Records: #{total_count} | Bases: #{total_number_bases} | Separate Pieces: #{total_quantity}</td>
        <td>#{select_by.join(' ')}</td>
      </tr>
      <tr>
        <td>Replacement Cost: $#{format("%.2f",total_replacement_cost)}<br />Sell Value: $#{format("%.2f",total_replacement_value)}</td>
        <td>#{sort_fields.join(', ')}</td>
      </tr>
    </table>

  </div>
   <div>
  <table class="sortable-theme-minimal" data-sortable id='report'>
   <thead><tr><th>#{header_row.join('</th><th>')}</th></tr></thead>
   <tbody>#{report_row_formatted}</tbody>
    </table>
    </div>
    </body></html> ~

  return 200, "text/html", report_html

end #format_results


  #create and return summary row
  def field_summary(summary_count, summary_field, summary_field_value, summary_cost='', summary_value='', summary_quantity='', summary_number_bases='', summary_genre='',report_format=nil, colspan=20)
    summary_row = String.new
    summary_cost = format("%.2f", summary_cost)
    summary_value = format("%.2f", summary_value)

    #used for drawer labels!
    genres = summary_genre.to_s.split(',')
    genres.flatten!
    genres.uniq!

  if report_format.to_s == '' then
    summary_row = %Q~<tr style="background-color:#dddddd;font-size:14pt;padding:8px;font-decoration:bold;"><td colspan=#{colspan}> <span style="font-weight:bold;">SUMMARY: #{summary_field_value} #{summary_field}</span> #{summary_count} records | quantity: #{summary_quantity} | number of bases: #{summary_number_bases} | replacement cost: $ #{summary_cost} | sell value: $ #{summary_value}</td></tr>\n~
  else
    summary_row = %Q~</table>
    <div style="display:inline-block;white-space:nowrap;font-size:97pt;height:100%;width:20%;float:left;">
      #{summary_field_value}
      <div style="display: inline-block;white-space:nowrap;font-size:24pt;">
        #{genres.join('<br />')}<br />
        <span style="font-style:italic;">#{summary_quantity} quantity / #{summary_number_bases} bases</span>
      </div>
    </div>

    <table id="report">~
  end

  return summary_row
  end



end #QueryResults Class

##################################################################
#Query
#Query page
#
##################################################################
class Query < WEBrick::HTTPServlet::AbstractServlet

  #prepare class for either get or post requests
  def do_GET(request, response)
    status, content_type, body = print_query(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def do_POST(request, response)
    status, content_type, body = print_query(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  #print query method
  def print_query(request)

    #are we deleting a saved report?
    if request.query['filter_for'].to_s == 'delete' then
      $saved_reports.delete(request.query['filter_by'])
      request.query['filter_by'] = 'undefined'
    end

    #create the saved report menu for display on the query form
    reports_menu = %Q~<div><table style="width:100%"><tr><th style="color:#8A8370;text-align:left;">saved queries</th><th style="color:#8A8370;">delete</th></tr>~
    reports_links = Array.new()
    $saved_reports.reports.each do |key, value|
        reports_links << %Q~<tr><td><a href="javascript:xmlhttpPost('/query','#{$saved_reports.reports[key].report_name}')">#{$saved_reports.reports[key].report_name}</a></td>
         <th><a href="javascript:xmlhttpPost('/query','#{$saved_reports.reports[key].report_name}','delete')"><span style='color:#8A2929;'>X</span></a></th></tr>~
    end
    reports_menu << reports_links.sort!.join('') << '</table></div>'

    #clean up the report name in order to prefill the form if a saved report has been requested
    report_name = String.new()
    report_name = request.query['filter_by']
    report_name = '' if report_name == 'undefined'

    #start the query form construction
    message = String.new()
    message = %Q~#{report_name}~

    #method variables
    query_html     = String.new
    query_html << %Q~<h1>Query Page</h1>~

    #columns
    selected_columns = Array.new()
    selected_columns[0] = ''
    unselected_columns = Array.new()

    #needed variables for filling in query form with saved report values
    query_name          = String.new()
    report_format       = String.new()
    exclude_html_format = String.new()
    exclude_summary     = String.new()
    order               = String.new()
    filter              = String.new()
    exact               = String.new()
    sort                = String.new()

    #more saved report values, dependent upon there being a saved report
    if report_name && report_name != '' then
      query_name    = $saved_reports.reports[report_name].query_name.to_s
      report_format = $saved_reports.reports[report_name].report_format.to_s == '' ? nil : 'checked="checked"'
      exclude_html_format = $saved_reports.reports[report_name].exclude_html_format.to_s == '' ? nil : 'checked="checked"'
      exclude_summary = $saved_reports.reports[report_name].exclude_summary.to_s == '' ? nil : 'checked="checked"'
    end

    #iterate through the instance variables of a new empty item object creating query form fields for each variable
    row = Item.new()

    row.instance_variables.sort.each do |var|
      value, display = var.to_s, var.to_s
      value.gsub!(/@/,'')
      display.gsub!(/@/,'')
      display.gsub!(/_/,' ')

      #saved report values -- assumes a report_name has been passed
      if report_name && report_name != '' then
        order  = $saved_reports.reports[report_name].instance_eval(value + '_order').to_s
        filter = $saved_reports.reports[report_name].instance_eval(value + '_filter').to_s
        exact  = $saved_reports.reports[report_name].instance_eval(value + '_exact').to_s == '' ?  nil : 'checked="checked"'
        sort   = $saved_reports.reports[report_name].instance_eval(value + '_sort').to_s == '' ? nil : 'checked="checked"'
      end

      #if we dealing with a saved report, order the columns by the column order value
      if order && order.to_i > 0 then
        selected_columns[order.to_i] = %Q~<li id='column_#{value}'>
              <span><input type='number' class='order_index'  id='#{value}_order'  name='#{value}_order'  value='#{order}' min='0' max='#{row.instance_variables.length}' style="width:3em;"/></span>
              <span style="display:inline-block;width:7em;">#{display}</span>
              <span><input type='text'     id='#{value}_filter' name='#{value}_filter' value='#{filter}' /> </span>
              <span><input type='checkbox' id='#{value}_exact'  name='#{value}_exact'  #{exact} /><span style='color:#8A8370;font-size:9pt;vertical-align:middle;'>exact </span></span>
              <span><input type='checkbox' id='#{value}_sort'   name='#{value}_sort'   #{sort} /><span style='color:#8A8370;font-size:9pt;vertical-align:middle;'>sort</span></span>
              </li>~
      else #else append the column to the end of the list
      unselected_columns.push(%Q~<li id='column_#{order}'>
            <span><input type='number' class='order_index'  id='#{value}_order'  name='#{value}_order'  value='#{order}' min='0' max='#{row.instance_variables.length}' style="width:3em;"/></span>
            <span style="display:inline-block;width:7em;">#{display}</span>
            <span><input type='text'     id='#{value}_filter' name='#{value}_filter' value='#{filter}' /> </span>
            <span><input type='checkbox' id='#{value}_exact'  name='#{value}_exact'  #{exact} /><span style='color:#8A8370;font-size:9pt;vertical-align:middle;'>exact </span></span>
            <span><input type='checkbox' id='#{value}_sort'   name='#{value}_sort'   #{sort} /><span style='color:#8A8370;font-size:9pt;vertical-align:middle;'>sort</span></span>
            </li>~)
      end

      end #instance_variables.each

query_options_menu = %Q~<table style="width:100%;color:#8A8370;font-size:9pt;"><tr><th style="color:#8A8370;text-align:left;font-size:14pt;">query options</th></tr>
            <!-- tr><td><input type='checkbox' name='exclude_html_format' id='exclude_html_format' #{exclude_html_format} /> exclude html format</td></tr>
            <tr><td><input type='checkbox' name='report_format' id='report_format' #{report_format} /> label report format</td></tr>
            <tr><td><input type='checkbox' name='bulk_update' id='bulk_update' /> bulk update</td></tr>
            -->
            <tr><td><select name='report_type' id='report_type'>
                      <option value='standard'>standard</option>
                      <option value='bulk_update'>bulk update</option>
                      <option value='pie'>chart - pie</option>
                      <option value='bar'>chart - bar</option>
                      <option value='bar-stacked'>chart - bar-stacked</option>
                      <option value='bar-grouped'>chart - bar-grouped</option>
                      <option value='timeline'>chart - timeline</option>
                      <option value='labels'>drawer labels</option>
                      <option value='tab_delimited'>tab delimited</option>
                    </select>
                    <div><input type='checkbox' name='exclude_summary' id='exclude_summary' #{exclude_summary} /> exclude column one summary</div>
            </td></tr>
          </table>~

    query_html = %Q^<h1 style='width=100%;text-align:center;font-size:18pt;font-weight:bold;'>Query</h1>
      <div style='width:100%;float:left;'>
      <form id='query' name='query' method='POST' target='_blank' action='/query_results'>

        <div><h2>#{message}&nbsp;</h2><p>query name: <input type='text' name='query_name' id='query_name' value='#{query_name}'/> <input type='submit' value='generate report' /></div>

        <div style='float:left;'>
        <span style='color:#8A8370;font-size:12pt;align:center;width:4em;'>order</span>
        <span style='display:inline-block;width:7em;color:#8A8370;font-size:12pt;align:center;'>column</span>
        <span style='color:#8A8370;font-size:12pt;text-align:center;'>filter (use ~ for OR)</span>
        <ul id='sortlist'>
        #{selected_columns.join}
        #{unselected_columns.join}
        </ul>
        </div>

        <div id='queries' name='queries' style='float:right;'>
          #{query_options_menu}
          <p />
          #{reports_menu}
        </div>

      </form>
      </div>^

    #if AJAX return items_html here and exit
    if request.query['filter_by'] or request.query['search_for'] then
        return 200, "text/html", query_html
    end

#web page
html = %Q~<!DOCTYPE html>
<html lang="en">
<head>
  <title>#{$APPLICATION_NAME}</title>
  <link rel="stylesheet" type="text/css" href="../application_styles/application.css" />

  <style>
  /* (A) LIST STYLES */
  .slist {
    list-style: none;
    padding: 0;
    margin: 0;
  }
  .slist li {
/*    border: 1px solid #333;
    margin: 5px;
    padding: 10px;
    background: #eaeaea;
*/
  }

  /* (B) DRAG-AND-DROP HINT */
  .slist li.hint { background: #fea; }
  .slist li.active { background: #ffd4d4; }
</style>


  #{Ajax.new.script}
  #{Javascript.new.script}
 #{Sortable_javascript.new.script}
</head>

<body onload="showDivs(['button_genre','button_tags','button_category','button_material','button_location','button_core']);">
  <div id="content">
    <div id="items" name="items">
      #{query_html}
    </div>
  </div>

  <div id="menu" class="menu">
    #{Banner.new.html}
    #{Menu.new('QUERY',$PICKLISTS).html}
    <a href="./application_resources/about.html" target="_new"><h3 style="text-align:center;color:#8A8370;">about #{$APPLICATION_NAME} #{$VERSION}<br /><img src="./application_resources/GPLv3.png" /></h3></a>
  </div>


 #{Collapsible_javascript.new.script}

 <!-- (C) INIT ON PAGE LOAD -->
 <script>
    window.addEventListener("DOMContentLoaded", function(){slist("sortlist");});
 </script>


</body></html>~

  return 200, "text/html", html
  end #print_query

end # Class Query


##################################################################
#PeekItem
#Complete showing of a single item
#
##################################################################
class PeekItem < WEBrick::HTTPServlet::AbstractServlet

  #prepare class for either get or post requests
  def do_GET(request, response)
    status, content_type, body = print_peek(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def do_POST(request, response)
    status, content_type, body = print_peek(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def print_peek(request)

    html = String.new

    key = request.query['id']
    subset = $collection.select('id', key, 'exact')
    subset_ids = $collection.sort(subset,['id'])

    subset_ids.each do | key |
  #standard fields
  id           = $collection.items[key].id
  name         = $collection.items[key].name
  description  = $collection.items[key].description
  location     = $collection.items[key].location
  genre        = $collection.items[key].genre
  tags         = $collection.items[key].tags
  cost         = $collection.items[key].cost
  value        = $collection.items[key].value
  acquired     = $collection.items[key].acquired
  added        = $collection.items[key].added
  image_dir    = $collection.items[key].image_dir
  icon_image   = $collection.items[key].icon_image
  item_image   = $collection.items[key].item_image
  web_url      = $collection.items[key].web
  notes        = $collection.items[key].notes
  #application specific fields
  type         = $collection.items[key].type
  manufacturer = $collection.items[key].manufacturer
  quantity     = $collection.items[key].quantity
  scale        = $collection.items[key].scale
  status       = $collection.items[key].status
  category     = $collection.items[key].category
  number_bases = $collection.items[key].number_bases
  base_size    = $collection.items[key].base_size
  rule_system  = $collection.items[key].rule_system
  material     = $collection.items[key].material
  painter      = $collection.items[key].painter
  completed    = $collection.items[key].completed

 item_images = String.new()
 item_image.split(',').each do |image|
   item_images << %Q~<img src="../application_images/#{image}" style="float:left;"" />~
 end #each image

 unless icon_image.match('.') then icon_image = "default.png" end

html << %Q~<html lang="en">
<head>
<title>Muster</title>
 <link rel="stylesheet" type="text/css" href="../application_styles/application.css" />

 <style>
 .label {
    width: 19%;
    float:left;
    padding-top: 0.5em;
 }
 .identifier {
   font-size: 10px;
 }
 .section {
   width:95%;
   color:#8a8370;
   background-color:#c9c9b7;
   padding:1px;
   font-weight: bold;
 }

 </style>
</head><body>
<div id="content" style="width:95%" >
<div class="item">
  <img class="icon" name='icon_picture' style="float:left;" id='icon_picture' src='../application_images/#{icon_image}' alt="icon picture" /><h1 class="name"> #{name}</h1>
  <div style="width:100%;"><span class='identifier'>description</span><br />#{description}</div>
  <br style="clear:both;" />

        <div class="section">&#8227; id: #{id}</div>
          <div class="label"><span class='identifier'>manufacturer</span><br />#{manufacturer}</div>
          <div class="label"><span class='identifier'>qty</span><br />#{quantity}</div>
          <div class="label"><span class='identifier'>type</span><br />#{type}</div>
          <div class="label"><span class='identifier'>category</span><br />#{category}</div>
          <div class="label"><span class='identifier'>material</span><br />#{material}</div>
          <br style="clear:both;" />

          <div class="label"><span class='identifier'>acquired date</span><br />#{acquired}</div>
          <div class="label"><span class='identifier'>cost</span><br />#{cost}</div>
          <div class="label"><span class='identifier'>value</span><br />#{value}</div>
          <div class="label"><span class='identifier'>location</span><br />#{location}</div>
          <div class="label"><span class='identifier'>status</span><br />#{status}</div>
          <br style="clear:both;" />

          <div class="label"><span class='identifier'>genre</span><br />#{genre}</div>
          <div class="label"><span class='identifier'>tags</span><br />#{tags}</div>
          <div class="label"><span class='identifier'>project / rules system</span><br />#{rule_system}</div>
          <div class="label"><span class='identifier'> </span><br /> </div>
          <div class="label"><span class='identifier'>completed date</span><br />#{completed}</div>

        <br style="clear:both;" />
        <div class="section">&#8227; figures</div>
          <div class="label"><span class='identifier'>scale</span><br />#{scale}</div>
          <div class="label"><span class='identifier'>bases</span><br />#{number_bases}</div>
          <div class="label"><span class='identifier'>base size</span><br />#{base_size}</div>
          <div class="label"><span class='identifier'>painter</span><br />#{painter}</div>
          <br style="clear:both;" />

        <div class="section">&#8227; links / notes</div>

          <div class="label"><span class='identifier'>web review / source</span><br /><a href="#{web_url}">#{web_url}</a></div>
          <div class="label"><span class='identifier'>notes</span><br />#{notes}</div>

        <br style="clear:both;" />
        <div class="section">&#8227; images</div>

          <div><span class='identifier'>icon</span><br />#{icon_image}<br /><img class="icon" name='icon_picture' style="float:left;" id='icon_picture' src='../application_images/#{icon_image}' alt="icon picture" /></div>
          <br style="clear:both;" />
          <div><span class='identifier'>item image</span><br />#{item_image}<br />
          #{item_images}
        </div>
</div>
</div>
</body></html>
~

end #each key
    return 200, "text/html", html

  end #print_peek

end #PeekItem




##################################################################
#ShowItems
#Primary interface for displaying items in the collection
#
##################################################################
class ShowItems < WEBrick::HTTPServlet::AbstractServlet

  #prepare class for either get or post requests
  def do_GET(request, response)
    status, content_type, body = print_listing(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def do_POST(request, response)
    status, content_type, body = print_listing(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  #print listing method
  def print_listing(request)

    message = String.new()

    #method variables
    count_items    = 0
    found_count    = 0
    items_html     = String.new
    search_term    = String.new

    total_cost = 0
    total_value = 0

    all_locations = Array.new()
    item_locations = Hash.new()

    search_filter_desc = String.new()

    subset = {}

    subset = $collection.select(request.query['filter_by'], request.query['filter_for'], request.query['filter_scope'])
    subset_ids = []

    #if not looking for anything specific, list the items in the most recent added/updated date first else list by name
    if request.query['filter_by'] == '' || request.query['filter_by'] == nil then
      #default to showing most recent items
      subset_ids = $collection.sort(subset, 'age')
       message << "10 most recently edited items."
    else
      #order the subset alphabetically by name
      subset_ids = $collection.sort(subset,['name'])
      message <<  %Q~Items with #{request.query['filter_by']}  #{request.query['filter_scope'] == 'exact' ? 'exactly matching ' : 'containing '} '#{request.query['filter_for']}', sorted alphapetically by name.~
    end


    subset_ids.each do | key |
      count_items += 1

      #clean the data
      id           = $collection.items[key].id
      title        = $collection.items[key].name #.downcase.gsub(/\b\w/){$&.upcase} #lc/uc all titles
      name         = $collection.items[key].name
      #description?
      #if no location is retrieved show 'at large'
      location         =  $collection.items[key].location.empty? ? 'at large' : $collection.items[key].location
        all_locations.push(location) if !location.empty?
        item_locations[location] = item_locations[location].to_s. + ",#{id.to_s}"
      cost         = $collection.items[key].cost
      value        = $collection.items[key].value
      acquired     = $collection.items[key].acquired
      added        = $collection.items[key].added
      image_dir    = $collection.items[key].image_dir
      icon_image   = $collection.items[key].icon_image
      item_image   = $collection.items[key].item_image
      web_url      = $collection.items[key].web
      #notes?
      type         = $collection.items[key].type
      manufacturer = $collection.items[key].manufacturer
      quantity     = $collection.items[key].quantity
      scale        = $collection.items[key].scale
      status       = $collection.items[key].status
      category     = $collection.items[key].category
      number_bases = $collection.items[key].number_bases
      base_size    = $collection.items[key].base_size
      rule_system  = $collection.items[key].rule_system
      material     = $collection.items[key].material


      #temporary default icon image
      if $collection.items[key].icon_image != nil && $collection.items[key].icon_image != '' then
        icon_image = %Q~<img class='icon'  src='../#{image_dir}/#{icon_image}' alt='#{icon_image}' onMouseOver="this.style.opacity='0.5'" onMouseOut="this.style.opacity='1.0'" />~
      else
        icon_image = %Q~<img class='icon'  src='../#{image_dir}/default.png' alt="default image" onMouseOver="this.style.opacity='0.5'" onMouseOut="this.style.opacity='1.0'" />~ #lion with sword image
      end
      #show just the date for added, not the entire date-time strings
      added = added.slice(0,10)

	  #item image
      view_url = String.new
      if item_image != nil && item_image != '' then
        view_button = %Q~<button type="button" class="image-view-button" id="button_#{id}_image">&#8227; view</button>~
        pictures = item_image.split(',')
        item_image = %Q~<div class="image-view" id="#{id}_image">~
        pictures.each do |picture|
         item_image << %Q~<img src="../#{image_dir}/#{picture}" style="max-width:800px;max-height:300px;float:left;" alt="#{picture}" />~
        end
        item_image << %Q~</div>~
      else
		    item_image = ''
	    end

      #supply url if available to open from browser
      web_url = String.new
      if $collection.items[key].web.to_s.match(/[a-z0-9]/i)then
        web_url = %Q~ | <a target='_blank' href='#{$collection.items[key].web}'> open</a>~
      end

      #note use of encoding method to clear an "invalid byte sequence in UTF-8" error. See http://www.ruby-forum.com/topic/208730 for an explaination.
      #It appears that some of the descriptions in database contain non-UTF-8 characters but ARE recognized as UTF-8.
      #Transcoding to UTF-16BE and then back to UTF-8 with the :invalid option cleans out the invalid characters.
      if $collection.items[key].description != nil then
         description = $collection.items[key].description.encode("UTF-16BE", :invalid=>:replace, :replace=>"?").encode("UTF-8")
         #now that we've cleaned the encoding we can do a bit more clean up using regular expressions
         description.gsub!(/\n/, ' ')
         description.gsub!(/ +/, ' ')
      end

	    #check id and scrub it
      id = $collection.items[key].id
      id.to_s.gsub!(/[^0-9]/, '')

      #add to the total cost
      if $collection.items[key].cost != nil then
        total_cost += $collection.items[key].cost.to_f
      end

      #add to the total value; add cost to value if no independent value is stored
      if $collection.items[key].value != nil && $collection.items[key].value.to_f > 0.0 then
         total_value += $collection.items[key].value.to_f
      elsif $collection.items[key].cost != nil then
         total_value += $collection.items[key].cost.to_f
      end

      display_state = 'block'
      #output the record limit to 10 items for first display
      if request.query['filter_by'] or count_items < 11 then
        found_count += 1
        items_html << %Q~<div class="item" id='#{id}' style="display:#{display_state}; clear:both;padding-top:2em;" >
                         <div style="float:left;text-align:center;overflow:hidden;">
                            <a href='/peek?id=#{id}' style="font-size:8pt;color:gray;" title="peek at #{name} details" onclick="peek(this.href);return false">#{icon_image}</a>
                        </div>
                         <div style="float:left;width:80%;overflow:hidden;">
                            <span class='name'>#{name} </span><br />
                             #{manufacturer} | #{quantity} #{scale} #{material} #{type} #{category} #{web_url}<br />
                            <span style='font-size:18pt;'>#{description}</span><br />
                            <span class='identifier'><a href='/manage_item?id=#{id}' title="edit #{name}" onMouseOver="this.style.color='black'" onMouseOut="this.style.color='#91b8b8'" style="color:#91b8b8;">edit id:#{id}</a> | location: #{location} | status: #{status} | updated: #{added}</span><br />
                            Related: ~

        #make comma delimited genres into unique links
        related_links = Array.new()
        if $collection.items[key].genre != '' then
          $collection.items[key].genre.split(',').each do |genre|
              related_links << %Q~<a href="javascript:xmlhttpPost('/items','genre','#{genre}','');">#{genre.downcase}</a>~
            end
        end

        #make comma delimited tags into unique links
        if $collection.items[key].tags != '' then
          $collection.items[key].tags.split(',').each do |tag|
              related_links << %Q~<a href="javascript:xmlhttpPost('/items','tags','#{tag}','');">#{tag.downcase}</a>~
          end
        end
        items_html << %Q~#{related_links.join(', ')}<br />#{view_button}#{item_image}</div></div>\n~
      end
    end #of each row processing

    #add summary to beginning of item list
    message = %Q~<div style="width:100%;text-align:center;"><h1>Search Results</h1><h2>#{message}</h2><p style="color:#8A8370;width:100%;text-align:center;">Showing #{found_count} of #{count_items} items.</p></div>~
    #add message to items div here because if it's a search result, the entire html is not sent. just the items div
    items_html = %Q~#{message} #{items_html}~

    #if AJAX return items_html here and exit
    if request.query['filter_by'] or request.query['search_for'] then
        return 200, "text/html", items_html
    end

#web page
html = %Q~<!DOCTYPE html>
<html lang="en">
<head>
<title>#{$APPLICATION_NAME}</title>
 <link rel="stylesheet" type="text/css" href="../application_styles/application.css" />
 #{Ajax.new.script}
 #{Javascript.new.script}

<script>
 // Popup window function
 	function peek(url) {
 popupWindow = window.open(url,'popUpWindow','height=700,width=800,left=200,top=200,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no,status=no');
 	}
 </script>

</head>
<body onload="showDivs(['button_location','button_genre','button_rule_system','button_tags','button_scale','button_category']);">
<div id="content" >
  <div id="items">
     #{items_html}
  </div>
</div>

<div id="menu" class="menu">
  #{Banner.new.html}
  #{Search.new().html}
  #{Menu.new('SEARCH',$MENUS).html}
  <a href="./application_resources/about.html" target="_new"><h3 style="text-align:center;color:#8A8370;">about #{$APPLICATION_NAME} #{$VERSION}<br /><img src="./application_resources/GPLv3.png" /></h3></a>
</div>

#{Collapsible_javascript.new.script}
#{Collapsible_javascript.new.script('image-view-button')}
</body></html>~

    return 200, "text/html", html
  end


  # #
end # Class ShowItems





##################################################################
# ManageItems
# Allows editing and adding of individual items
#
##################################################################
class ManageItems < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    status, content_type, body = item_form(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def do_POST(request, response)
    if request.query['id'] and request.query['name']
       status, content_type, body = save_item(request)
    else
      status, content_type, body = item_form(request)
    end
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  #item form method
  def item_form(request)
  id = String.new
  entry_form = String.new

  #if request.query['id'] != nil then
  id = request.query['id']

  if id == nil || id == '' then #new item
     entry_form << item_form_template()
  else
     id.strip!
     id.gsub!(/[^0-9]/,'') #ensure we are editing a legitimate id

     #Why do I have to have a subset and then an array of keys? I don't understand why this is necessary!
     #Why can't I simple use $collection.items[id].location where id is the key of the item in the collection?
     subset = {}
     subset = $collection.select('id',id,'exact')
     subset_ids = []
     subset_ids = $collection.sort(subset, ['id'])

     subset_ids.each do | id |
       entry_form << item_form_template(
          $collection.items[id].id,
          $collection.items[id].name,
          $collection.items[id].description.encode("UTF-16BE", :invalid=>:replace, :replace=>"?").encode("UTF-8"),
          $collection.items[id].location,
          $collection.items[id].genre,
          $collection.items[id].tags,
          $collection.items[id].cost,
          $collection.items[id].value,
          $collection.items[id].acquired,
          $collection.items[id].added,
          $collection.items[id].image_dir,
          $collection.items[id].icon_image,
          $collection.items[id].item_image,
          $collection.items[id].web,
          $collection.items[id].notes,
          $collection.items[id].type,
          $collection.items[id].painter,
          $collection.items[id].completed,
          $collection.items[id].quantity,
          $collection.items[id].scale,
          $collection.items[id].manufacturer,
          $collection.items[id].status,
          $collection.items[id].category,
          $collection.items[id].number_bases,
          $collection.items[id].base_size,
          $collection.items[id].rule_system,
          $collection.items[id].material
        )
     end #each subset_id
  end #else
    #return the empty or populated page
    return 200, "text/html", entry_form

  end #end item_form


  def item_form_template(
        id="",
        name="",
        description="",
        location="at large",
        genre="",
        tags="",
        cost="",
        value="",
        acquired="",
        added="",
        image_dir="",
        icon_image="",
        item_image="",
        web="",
        notes="",
        type = '',
        painter = '',
        completed = '',
        quantity = '',
        scale = '',
        manufacturer = '',
        status = '',
        category = '',
        number_bases = '',
        base_size = '',
        rule_system = '',
        material = ''
      )

      #control to delete uploaded document
      delete_web = String.new('')
      if web.to_s != nil && web.match(/publications/) then
        delete_web = %Q~<input type="checkbox" name="delete_doc" id="delete_doc}" /> delete #{web}~
      end

     #default image
      if icon_image != nil then
        icon_image = icon_image
      else
        icon_image = 'default.png' #lion with sword image
      end

       #default image directory
      if image_dir != nil then
        image_dir = image_dir
      else
        image_dir = 'application_images' #default image directory
      end

      #handle multiple item images separated by comma
      item_images = String.new()
      pictures = item_image.split(',')
      pictures.each do |picture|
        item_images << %Q~<img src="../#{image_dir}/#{picture}" style="max-width:800px;max-height:300px;" alt="#{picture}" /><br /><input name="delete_#{picture}" id="delete_#{picture}" type="checkbox" /> delete image #{picture}<br />~
      end

      #import and sort a tags list if available
      tag_list = Array.new()

      if File.file?('tags.txt') then
        tag_list = File.readlines('tags.txt')

        if tag_list.length > 0 then
         tag_list.flatten!
         tag_list.uniq!

         #sort the attributes numerics first, then strings
#         tag_list = tag_list.sort_by do |s|
#           if s =~ /^\d+\.?\d*$/
#             [1, $&.to_f]
#           else
#             [2, s]
#           end
#         end #sort_by
       end #tag_list.length > 0

       tag_list.map! { |tag|
         %Q~<option value="#{tag}">~
       }
     end # if File.file? exists

return html = %Q~<!DOCTYPE html>
<html lang="en">
<head>
  <title>#{$APPLICATION_NAME}</title>
  <link rel="stylesheet" type="text/css" href="../application_styles/application.css" />
  #{Ajax.new.script}
  #{Javascript.new.script}
</head>
<body onload="showDivs(['button_genre','button_tags','button_category','button_material','button_location','button_core']);">
    <div id="content">
      <div id="items">
      <h1 style="width:100%;text-align:center;">#{name != nil && name != '' ? 'Editing ' + name : 'Adding new item'}.</h1>


      <form method='POST' action='/save_item' enctype="multipart/form-data">
        <button  type="button" class="collapsible" id="button_save" style="color:#8a8370;background-color:#c9c9b7;padding:1px;">&#8227; save <input type='submit' value='save' style="width:75px;height:28px;font-weight:bold;font-size:18px;float:right;"/></button>
        <br style="clear:both;" />
        <img class="icon" name='icon_picture' style="float:left;" id='icon_picture' src='../#{image_dir}/#{icon_image}' alt="icon picture" /><h1> #{name}</h1>
        <br style="clear:both;" />

        <button type="button" class="collapsible" id="button_core" style="color:#8a8370;background-color:#c9c9b7;padding:1px;">&#8227; core attributes</button>
        <div id="core" class="attributes" >
          <div class="item" style="padding-bottom:1px;float:left;">name*<br /><input name='name' id='name' type='text' size='50rem' value="#{name}" />
            <input name='id' id='id' type='hidden' value='#{id}' /></div>
            <div class="item" style="float:left;text-align:center;">#{$APPLICATION_NAME} id<br />#{id}</div>
            <br style="clear:both;" />
            <div class="item" style="padding-bottom:2px;">description<br /><textarea name='description' id='description' rows="8" cols="60rem">#{description}</textarea></div>
            <br style="clear:both;" />
            <div class="item" style="float:left;padding-bottom:2px;">genre*<br /><input name='genre' id='genre' type='text' size="15rem" value='#{genre}' /></div>
            <div class="item" style="float:left;padding-bottom:2px;">tags<br /><input name='tags' id='tags' type='text' size="31rem" value='#{tags}' /></div>
            <br style="clear:both;" />
            <div class="item" style="float:left;padding-bottom:2px;">qty<br /><input name='quantity' id='quantity' type='number' size="3rem" value='#{quantity}' /></div>
            <div class="item" style="float:left;padding-bottom:2px;" >category*<br /><input name='category' id='category' type='text' size="11rem" value='#{category}' /></div>
            <div class="item" style="float:left;padding-bottom:2px;">material<br /><input name='material' id='material' type='text' size="11rem" value='#{material}' /></div>
            <div class="item" style="float:left;padding-bottom:2px;">manufacturer<br /><input name='manufacturer' id='manufacturer' type='text' size="11rem" value='#{manufacturer}' /></div>
            <br style="clear:both;" />
            <div class="item" style="float:left;padding-bottom:2px;" >project / rules system<br /><input name='rule_system' id='rule_system' type='text' size="50rem" value='#{rule_system}' /></div>
            <br style="clear:both;" />
            <div class="item" style="float:left;padding-bottom:2px;">location<br /><input name='location' id='location' size="11rem" type='text' value='#{location}' /></div>
            <div class="item" style="float:left;padding-bottom:2px;">cost<br /><input name='cost' id='cost' type='text' size="3rem" value='#{cost}' /></div>
            <div class="item" style="float:left;padding-bottom:2px;">acquired date<br /><input name='acquired' id='acquired' type='date' size="11rem" value='#{acquired}' /></div>
        </div> <!-- end core div -->

        <button type="button" class="collapsible" id="button_scale" style="color:#8a8370;background-color:#c9c9b7;padding:1px;">&#8227; scale</button>
        <div id="figures" class="attributes">
          <div class="item" style="float:left;padding-bottom:2px;">scale<br /><input name='scale' id='scale' type='text' size="3rem" value='#{scale}' /></div>
          <div class="item" style="float:left;padding-bottom:2px;">type<br /><input name='type' id='type' type='text' size="11rem" value='#{type}' /></div>
          <br style="clear:both;" />
        </div>

        <button type="button" class="collapsible" id="button_finish" style="color:#8a8370;background-color:#c9c9b7;padding:1px;">&#8227; status</button>
        <div id="status_div" class="attributes">
          <div class="item" style="float:left;padding-bottom:2px;" >base size<br /><input name='base_size' id='base_size' type='text' size='11rem' value='#{base_size}' /></div>
          <div class="item" style="float:left;padding-bottom:2px;" >bases<br /><input name='number_bases' id='number_bases' type='number' size='3rem' value='#{number_bases}' /></div>
          <div class="item" style="float:left;padding-bottom:2px;">painter<br /><input name='painter' id='painter' type='text' size='11rem' value='#{painter}' /></div>
          <br style="clear:both;" />
          <div class="item" style="float:left;padding-bottom:2px;">status<br /><input name='status' id='status' type='text' size='11rem' value='#{status}' /></div>
          <div class="item" style="float:left;padding-bottom:2px;">value<br /><input name='value' id='value' type='text' size='3rem' value='#{value}' /></div>
          <div class="item" style="float:left;padding-bottom:2px;" >completed date<br /><input name='completed' id='completed' type='date' size='11rem' value='#{completed}' /></div>
          <br style="clear:both;" />
        </div>

        <button type="button" class="collapsible" id="button_images" style="color:#8a8370;background-color:#c9c9b7;padding:1px;">&#8227; images</button>
        <div id="images" class="attributes">
          <div class="item" style="padding-bottom:2px;">icon<br /><input name='icon_image' id='icon_image' type='text' size="50rem" value='#{icon_image}' />
          <input type="file" accept=".png,.jpg,.jpeg" id="icon_file" name="icon_file" onchange="change_icon_image(this, event);" /></div><br />
            <img class="icon" name='icon_picture' id='icon_picture' src='../#{image_dir}/#{icon_image}' alt="icon picture" />
          <br style="clear:both;" />

          <div class="item" style="padding-bottom:2px;" >item image<br /><input name='item_image' id='item_image' type='text' size="50rem" value='#{item_image}' />
          <input type="file" accept=".png,.jpg,.jpeg" id="image_file" name="image_file" onchange="change_item_image(this, event);" /></div><br />
          <img id='item_picture' name='item_picture' src='' style="max-width:800px;max-height:300px;" alt="new_picture" /><br />
            #{item_images}
          <br style="clear:both;" />
        </div>

        <button type="button" class="collapsible" id="button_links" style="color:#8a8370;background-color:#c9c9b7;padding:1px;">&#8227; links / upload documents</button>
        <div id="links" class="attributes">
          <br style="clear:both;" />
          <div class="item" style="padding-bottom:2px;" >web review / source<br /><input name='web' id='web' type='text' size="50rem" value='#{web}' /><br />
          <input type="file" accept=".pdf" id="document" name="document" onchange="change_web(this);" />
          #{delete_web}
          </div>
          <br style="clear:both;" />
          <div class="item" style="float:left;padding-bottom:2px;" >notes<br /><input name='notes' id='notes' type='text' size="50rem" value='#{notes}' /></div>
          <br style="clear:both;" />
        </div>

     </form>
     <button type="button" class="collapsible" id="button_delete" style="color:#8a8370;background-color:#c9c9b7;padding:1px;">&#8227; delete</button>
     <div id="delete" class="attributes">
       #{Delete.new(id).html}
     </div>

     </div>
   </div>
   <div id="menu" class="menu">
     #{Banner.new.html}
     #{Menu.new('PICKLIST',$PICKLISTS).html}
     <a href="./application_resources/about.html" target="_new"><h3 style="text-align:center;color:#8A8370;">about #{$APPLICATION_NAME} #{$VERSION}<br /><img src="./application_resources/GPLv3.png" /></h3></a>
   </div>

  #{Collapsible_javascript.new.script}
  </body></html>
      ~
    end #end of item_form_template

end #Class ManageItems


##################################################################
# Banner
# Returns the top banner centered and linked to main page
#
##################################################################
class Banner

  def html
    return %Q~<div class="item" style="width:100%;text-align:center;">
      <a href="#{$SERVER}:#{$PORT}/items"><img src='../application_resources/application_banner.png' alt='application banner image' style="80%;"/></a><br />
    <div class="sibling-fade" style="width:90%;">
        <a href="#{$SERVER}:#{$PORT}/items">Search</a>
        <a href="#{$SERVER}:#{$PORT}/manage_item">Add Item</a>
        <a href="#{$SERVER}:#{$PORT}/query">Query</a>
        <a target="_new" href="#{$SERVER}:#{$PORT}/application_resources/about.html">Help</a>
        <a href="#{$SERVER}:#{$PORT}/quit">Quit</a>
    </div>
</div>
    ~
  end #html

end #class Banner






##################################################################
# Menu
# Returns the necessary html code for the simple search list
##################################################################
class Menu
  def initialize(menu_type, attributes)
    @menu_type = menu_type
    @attributes = attributes
  end

  def html

    html = String.new

    #determine menu type and customize label
    if @menu_type == 'PICKLIST' then
      html << %Q~<h2>Attribute Picklist</h2>~
    elsif @menu_type == 'SEARCH' then
      html << %Q~<h2>Simple Search Attribute List</h2>~
    elsif @menu_type == 'QUERY' then
      html << %Q~<h2>Query Attribute List</h2>~
    end

    display = String.new

    @attributes.each do |attribute|
      all_attributes = Array.new

      #loop through the collection and pull the attribute values
      $collection.items.each do | key, item |
  	      temp = $collection.items[key].instance_eval(attribute).gsub(/\s*,\s*/,'~')
          temp.downcase!
          all_attributes.push(temp.split('~')) #create list of attribute values
      end #end each collection items do

      #clean up the attribute list
      if all_attributes.length > 0 then
         all_attributes.flatten!
         all_attributes.uniq!

         #sort the attributes numerics first, then strings
         all_attributes = all_attributes.sort_by do |s|
           if s =~ /^\d+\.?\d*$/
             [1, $&.to_f]
           else
             [2, s]
           end
         end #sort_by
      end #attributes.length > 0

      #location needs to be an exact search, the others can be more open
      if ['location'].index(attribute) then
        scope = 'exact'
      else
        scope = ''
      end

    html << %Q~\n<div class="collapsible" id='button_#{attribute.downcase}' >&#8227; #{attribute.downcase.gsub(/_/,' ')}</div>\n~
    html << %Q~<div class="attributes">\n~

      current_attribute_initial = String.new() #when this changes insert a separator
      separator = String.new()
      separator = '|'


      #loop through the attribute values appending them to the menu
      all_attributes.each{|attribute_value|

        if attribute != 'scale' && attribute != 'location' then
          if current_attribute_initial != attribute_value[0] then html << " &#10087; #{attribute_value[0].upcase} &#10087; " end
        end

        #modify the action of the link depending upon the menu type
        if @menu_type == 'PICKLIST' then
          html << %Q~<a href="javascript:fill_form_field('#{attribute}','#{attribute_value}');">#{attribute_value}</a> #{separator} ~
        elsif @menu_type == 'SEARCH' then
          html << %Q~<a href="javascript:xmlhttpPost('/items','#{attribute}','#{attribute_value}','#{scope}');">#{attribute_value}</a> #{separator} ~
        elsif @menu_type == 'QUERY' then
          html << %Q~<a href="javascript:fill_form_field('#{attribute}_filter','#{attribute_value}');">#{attribute_value}</a> #{separator} ~
        end

        current_attribute_initial = attribute_value[0]

      } #end all_attributes.each

    html << "\n</div>" #close attribute value div
  end #each attributes

  return %Q~<br style="clear:both;" />#{html}~

 end # html
end # Menu class









##################################################################
# Search
# Returns the necessary code to search the database
# Creates a new, blank item and uses the keys to create the
# drop down box for the search fields html
#
##################################################################
class Search

  def html

    all_columns = Array.new
    row = Item.new()

      row.instance_variables.each do |var|
          value, display = var.to_s, var.to_s
          value.gsub!(/@/,'')
          display.gsub!(/@/,'')
          display.gsub!(/_/,' ')
          all_columns << "<option value='#{value}'>#{display}</option>"
      end #instance_variables.each

   all_columns.sort!


return %Q~
<div style="width:90%;margin:auto;"><h3 style="text-align:center;">
 <form id='search' name='search' method='POST' action='/items'>
  <select id='filter_by' name='filter_by'>
    <option value="any" selected="selected">any field</option>
    #{all_columns.join('')}</select>
  <select id='filter_scope' name='filter_scope'><option value='contains'>contains</option><option value='exact'>exactly matches</option></select>
  <input type="text" id='filter_for' name='filter_for' size=15 value='enter search term' onfocus="this.value=''" style='color:#999999;background-color:#E9E4B3;' />
  <input type='button' onclick="javascript:xmlhttpPost('/items',document.search.filter_by.value,document.search.filter_for.value,document.search.filter_scope.value);" value='search' />
  <p style="margin-top:2px;border-top:2px solid #8A8370;width:100%;text-align:center;">seach function</p>
 </form>
 </h3>
</div>
~
  end # html
end #class Search




##################################################################
# Delete
# Returns the html which allows deletion of an item with confirmation
#
##################################################################

class Delete

  def initialize(id)
      @id = id
  end

  def html
  #delete function html string which appears only if editing an existing item
    delete_html = String.new
    if @id.to_s.match(/[0-9]+/) then
    delete_html = %Q~
     <div style="padding-bottom:2px;width:100%;text-align:left;">
     <form method='POST' action='/delete_item' >
       <input name='id' id='id' type='hidden' value='#{@id}' />
       <h1><input type="checkbox" style="height:28px;width:28px;" name="confirm_delete" id="confirm_delete" value="confirmed" /> enable delete then >> <input type='submit' style="font-weight:bold;font-size:18px;height:28px;float:right;" value='delete item ##{@id} from #{$APPLICATION_NAME}' /></h1>
     </form>
     </div>
    ~
    end
  return delete_html

end # of html

end #class Delete



##################################################################
# javascript
# Returns the necessary script to update only the content section
# of the web page when filtering the item list displate
#
##################################################################
class Javascript
def script
  return %Q~
<script type="text/javascript">
//old toggle id code
function toggle(divId) {
  var x = document.getElementById(divId);
  if (x.style.display === "none") {
      x.style.display = "block";
  } else {
    x.style.display = "none";
  }
}

function showDivs(buttons){
    buttons.forEach(button => document.getElementById(button).click());
}


//image handling in item edit
function change_web(file)
{
   document.getElementById('web').value = file.value;
};

function change_icon_image(file, event)
{
   document.getElementById('icon_image').value = file.value;
   var image = document.getElementById('icon_picture');
	 image.src = URL.createObjectURL(event.target.files[0]);
};

function change_item_image(file, event)
{
   if (document.getElementById('item_image').value.length > 0)
   {
     document.getElementById('item_image').value =  document.getElementById('item_image').value.concat(',', file.value);
   }
   else
   {
     document.getElementById('item_image').value = file.value;
   }

   var image = document.getElementById('item_picture')
   image.src = URL.createObjectURL(event.target.files[0]);
};


//used to fill in edit form from picklists
function fill_form_field(form_field, form_value)
{
  document.getElementById(form_field).value=form_value;
}

</script>
  ~ #end of return

  end #of script
end # of Javascript class


##################################################################
# Collapsible_javascript
# Returns the necessary script to update only the content section
# of the web page when filtering the item list displate
#
##################################################################
class Collapsible_javascript
  def script(button_style='collapsible', no_tags='')

    script = String.new()
    end_script = String.new()

    if (no_tags == '') then
      begin_script = '<script>'
      end_script = '</script>'
    end

    return %Q~
#{begin_script}
    //collapsible attribute code
    var coll = document.getElementsByClassName("#{button_style}");
    var i;

    for (i = 0; i < coll.length; i++)
    {
      coll[i].addEventListener("click", function()
      {
        this.classList.toggle("active");
        var content = this.nextElementSibling;
        if (content.style.maxHeight){
          content.style.maxHeight = null;
          content.style.opacity = 0;
      } else
      {
          content.style.maxHeight = content.scrollHeight + "px";
          content.style.opacity = 1;
      }
      });
    }
#{end_script}
~
end #script
end #class


##################################################################
# Sortable_javascript
# Returns the necessary script to update only the content section
# of the web page when filtering the item list displate
#
##################################################################
class Sortable_javascript
  def script(no_tags='')

    script = String.new()
    end_script = String.new()

    if (no_tags == '') then
      begin_script = '<script>'
      end_script = '</script>'
    end

    return %Q~
#{begin_script}

function renumber_sort_order () {
  var items = document.getElementsByTagName("li")
  var order = 1;
  for (let i=0; i<items.length; i++) {
      if(items[i].firstElementChild.firstElementChild.value > 0){
         items[i].firstElementChild.firstElementChild.value = order;
        order++;
      } //end of if items value > 0
  }//end of for let
} //end of sort_order function

function slist (target) {
  // (A) GET LIST + ATTACH CSS CLASS
  target = document.getElementById(target);
  target.classList.add("slist");

  // (B) MAKE ITEMS DRAGGABLE + SORTABLE
  var items = target.getElementsByTagName("li"), current = null;
  for (let i of items) {

    // (B1) ATTACH DRAGGABLE
    i.draggable = true;

    // (B2) DRAG START - YELLOW HIGHLIGHT DROPZONES
    i.addEventListener("dragstart", function (ev) {
      current = this;
      for (let it of items) {
        if (it != current) { it.classList.add("hint"); }
      }
    });

    // (B3) DRAG ENTER - RED HIGHLIGHT DROPZONE
    i.addEventListener("dragenter", function (ev) {
      if (this != current) { this.classList.add("active"); }
    });

    // (B4) DRAG LEAVE - REMOVE RED HIGHLIGHT
    i.addEventListener("dragleave", function () {
      this.classList.remove("active");
    });

    // (B5) DRAG END - REMOVE ALL HIGHLIGHTS
    i.addEventListener("dragend", function () {
      for (let it of items) {
        it.classList.remove("hint");
        it.classList.remove("active");
      }
    });

    // (B6) DRAG OVER - PREVENT THE DEFAULT "DROP", SO WE CAN DO OUR OWN
    i.addEventListener("dragover", function (evt) {
      evt.preventDefault();
    });

    // (B7) ON DROP - DO SOMETHING
    i.addEventListener("drop", function (evt) {
      evt.preventDefault();
      if (this != current) {
        let currentpos = 0, droppedpos = 0;
        for (let it=0; it<items.length; it++) {
          if (current == items[it]) { currentpos = it; }
          if (this == items[it]) {
              droppedpos = it;
              //update the column order input field to reflect the new position
              current.firstElementChild.firstElementChild.value = droppedpos + 1;
          }
        }
        if (currentpos < droppedpos) {
          this.parentNode.insertBefore(current, this.nextSibling);
        } else {
          this.parentNode.insertBefore(current, this);
        }
        renumber_sort_order();
      }
    });
  }
}
#{end_script}
~
end #script
end #class


##################################################################
# Ajax
# Returns the necessary script to update only the content section
# of the web page when filtering the item list displate
#
##################################################################
class Ajax
def script
    return %Q~
    <script>
    function xmlhttpPost(strURL, filter_by, filter_for, filter_scope) {
        var xmlHttpReq = false;
        var self = this;

        //allow special characters (such as ampersands) in query
        filter_by = encodeURIComponent(filter_by);
        filter_for = encodeURIComponent(filter_for);
        filter_scope = encodeURIComponent(filter_scope);

        var query = 'filter_by=' + filter_by +';filter_for=' + filter_for +';filter_scope='+filter_scope;

        // Mozilla/Safari
        if (window.XMLHttpRequest) {
            self.xmlHttpReq = new XMLHttpRequest();
        }
        // IE
        else if (window.ActiveXObject) {
            self.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
        }

        self.xmlHttpReq.open('POST', strURL, true);
        self.xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        self.xmlHttpReq.onreadystatechange = function() {
            if (self.xmlHttpReq.readyState == 4) {
                updatepage(self.xmlHttpReq.responseText);
            }
        }


        // Define a callback function
        self.xmlHttpReq.onload = function() {
          #{Collapsible_javascript.new.script('image-view-button','notags')};
          slist("sortlist");
        } //end of callback function


        self.xmlHttpReq.send(query);
  }

    function updatepage(str){
        document.getElementById("items").innerHTML = str;
    }
    </script>
  ~
  end #of script
end #of class





##################################################################
# DeleteItem
# Deletes individual item
#
##################################################################

class DeleteItem < WEBrick::HTTPServlet::AbstractServlet

   def do_GET(request, response)
    status, content_type, body = delete_item(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def do_POST(request, response)
    if request.query['id'] and request.query['confirm_delete']
       status, content_type, body = delete_item(request)
#       puts "do_POST 1"
    else
      warning = %Q~<script type="text/javascript">window.onload = function(){alert('You must first enable the delete before deleting an item from the database.');}</script>~
      status, content_type, body = 200, "text/html", %Q~<html><head>#{warning}<meta http-equiv="refresh" content="0;url=#{$SERVER}:#{$PORT}/manage_item?id=#{request.query['id']}"></head><body></body></html>~
#      puts "do_POST else"
    end
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end





  #delete item method
  def delete_item(request)

    id = String.new
    id = request.query['id']

    confirmed = String.new
    confirmed = request.query['confirm_delete']
    confirmed.strip!

    if confirmed != 'confirmed' or id.match(/[^0-9]+/) then
          return 200, "text/html", %Q~<html><head><meta http-equiv="refresh" content="0;url=#{$SERVER}:#{$PORT}/items"></head><body>Input doesn't validate</body></html>~
    else
       $collection.delete(id.to_i)

    #call first page with new/updated item
    return 200, "text/html", %Q~<html><head><meta http-equiv="refresh" content="0;url=#{$SERVER}:#{$PORT}/items"></head><body></body></html>~
    end #if else

  end #delete_item

  end #class DeleteItem



##################################################################
# SaveItems
# Inserts/Updates Individual Items
#
##################################################################

class SaveItems < WEBrick::HTTPServlet::AbstractServlet

 def do_POST(request, response)
    status, content_type, body = save_item(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

 def save_item(request)
    #save query values in variables for processing

    id           = request.query['id'].to_s.gsub(/\D/,'')
    name         = request.query['name'].to_s.gsub(/[^\w\s\.\-\,\(\)]/,'')
    description  = request.query['description'].to_s.gsub(/[^\w\s\.\-\,\(\)\;\&\:\'\"\/]/,'')
    location     = request.query['location'].to_s.gsub(/[^\w\s\.\-\,\(\)]/,'')
    genre        = request.query['genre'].to_s.gsub(/[^\w\s\.\-\,\(\)\&\/]/,'')
    tags         = request.query['tags'].to_s.gsub(/[^\w\s\.\-,()\/]/,'')
    cost         = request.query['cost'].to_s.gsub(/\D\./,'')
    value        = request.query['value'].to_s.gsub(/\D\./,'')
    acquired     = request.query['acquired'].to_s.gsub(/[^\w\s\.\-\,\(\)]/,'')
    added        = request.query['added'].to_s.gsub(/\D\//,'').gsub(/[^\w\s\.\-\,\(\)]/,'')
    image_dir    = request.query['image_dir'].to_s.gsub(/[^\w\s\.\-\,\(\)]/,'')
    icon_image   = request.query['icon_image'].to_s.gsub(/[^\w\s\.\-\,\(\)]\:\\/,'')
    item_image   = request.query['item_image'].to_s.gsub(/[^\w\s\.\-\,\(\)\:\\]/,'')
    web          = request.query['web'].to_s.gsub(/[^\w\s\.\-\,\(\)\\\:\/\?\&=]/,'')
    notes        = request.query['notes'].to_s.gsub(/[^\w\s\.\-\,\(\)\;\&\:\'\"]/,'')

    type         = request.query['type'].to_s.gsub(/[^\w\s\.\-\,\(\)]/,'')
    quantity     = request.query['quantity'].to_s.gsub(/\D/,'')
    scale        = request.query['scale'].to_s.gsub(/[^a-z0-9\s\/\:]/i,'')
    manufacturer = request.query['manufacturer'].to_s.gsub(/[^\w\s\.\-\,\(\)]/,'')
    status       = request.query['status'].to_s.gsub(/[^\w\s\.\-\,\(\)]/,'')
    painter      = request.query['painter'].to_s.gsub(/[^\w\s\.\-\,\(\)]/,'')
    completed    = request.query['completed'].to_s.gsub(/[^\w\s\.\-\,\(\)]/,'')
    category     = request.query['category'].to_s.gsub(/[^\w\s\.\-\,\(\)]/,'')
    number_bases = request.query['number_bases'].to_s.gsub(/\D/,'')
    base_size    = request.query['base_size'].to_s.gsub(/[^\w\s\.\-\,\(\)]/,'')
    rule_system  = request.query['rule_system'].to_s.gsub(/[^\w\s\.\-,()\&\/]/,'')
    material     = request.query['material'].to_s.gsub(/[^\w\s\.\-\,\(\)]/,'')

#    enabling this line saves the actual document in the yaml file--probably not what we want to do!
    #document     = request.query['document'].to_s.gsub(/[^\w\s\.\-\,\(\)\:\\\/]/,'')

    error_msg = String.new

    #need to put in some error checking here: make title, ensure isbn is valid or null (which will result in a new rowid being used).

    #... save the documents if there are any, could be rules or images
    rule_dir = "publications"
    if request.query['document'] && request.query['document'] != '' && web != nil then
       web.gsub!(/.:\\fakepath\\/i, '')
       rule_file = File.join(rule_dir, web) #request.query['document'])
       web = "#{rule_dir}/#{web}"
#       puts web
#      save uploaded document
       File.open(rule_file, 'w') { |file| file.write(request.query['document']) }
    end
    #... delete the document if indicated and set web to nil in data
    if request.query['delete_doc'] != nil && web.to_s.match(/publications/)then
      if File::exists?(web) then
        File.delete(web)
        web = ''
      end
    end

    #... save the icon_image image if there is one
    image_dir = "application_images"
    if request.query['icon_file'] && request.query['icon_file'] != '' && icon_image != nil then
       icon_image.gsub!(/.:\\fakepath\\/i, '')
       icon_file = File.join(image_dir, icon_image)
       File.open(icon_file, 'w') { |file| file.write(request.query['icon_file']) }
    end

    #... save the item_image if there is one or more
    if request.query['image_file'] && request.query['image_file'] != '' && item_image != nil then
       item_image.split(',').each do |picture|
         if picture.match(/.:\\fakepath\\/) then
           picture.gsub!(/.:\\fakepath\\/i, '')
           item_file_name = File.join(image_dir, picture)
           File.open(item_file_name, 'w') { |file| file.write(request.query['image_file']) }
         end
       end
      item_image.gsub!(/.:\\fakepath\\/i, '')
    end

    #... check and delete indicated item_images
    if item_image != nil then
      item_image.split(',').each do |picture|
        to_delete = "delete_#{picture}"
        if request.query[to_delete] != nil then
          file = "#{image_dir}/#{picture}"
          if File::exists?(file) then
            File.delete(file)
            #remove the picture name from image list and clean up commas in list
            item_image.gsub!(picture, '')
            item_image.gsub!(/^\s*,\s*/,'')
            item_image.gsub!(/\s*,\s*$/,'')
            item_image.gsub!(/\s*,\s*,\s*/,',')
          end #file exists?
       end #if requested delete
    end #do each picture`
  end #if item_image

    #let's do some clean up on the fields
    name.strip!
    name.gsub!(/\'\'+/, "'")
    name.gsub!(/\s\s+/, ' ')
    if !name then
      name = 'UNTITLED'
    end

    price = price ||= 0.00 #price or zero (instead of null)
    value = value ||= 0.00 #value or zero (instead of null)

    location =  location.empty? ? 'at large' : location

    description.gsub!(/\n/, ' ')
    description.gsub!(/ +/, ' ')

    genre.strip!
    genre.gsub!(/^\s*,/,'')
    genre.downcase!
    genre = 'unknown' if genre.empty?

    if tags != nil then
       tags.strip!
       tags.downcase!
    end

    added = DateTime.new().to_s

    if notes != nil then
       notes.gsub!(/[\n +]/, ' ')
    end

    if type != nil then
       type.strip!
    end

  #create a new item, $collection.add will add or update if the id already exists
  new_item =  Item.new()

  #populate the item instance variables with the validated web form values
  new_item.id,
  new_item.name,
  new_item.description,
  new_item.location,
  new_item.genre,
  new_item.tags,
  new_item.cost,
  new_item.value,
  new_item.acquired,
  new_item.added,
  new_item.image_dir,
  new_item.icon_image,
  new_item.item_image,
  new_item.web,
  new_item.notes,
  new_item.quantity,
  new_item.scale,
  new_item.type,
  new_item.manufacturer,
  new_item.status,
  new_item.painter,
  new_item.completed,
  new_item.category,
  new_item.number_bases,
  new_item.base_size,
  new_item.rule_system,
  new_item.material =
  id,
  name,
  description,
  location,
  genre,
  tags,
  cost,
  value,
  acquired,
  added,
  image_dir,
  icon_image,
  item_image,
  web,
  notes,
  quantity,
  scale,
  type,
  manufacturer,
  status,
  painter,
  completed,
  category,
  number_bases,
  base_size,
  rule_system,
  material


  $collection.add(new_item)

  #call first page with new/updated item only (?)
  return 200, "text/html", %Q~<html><head><meta http-equiv="refresh" content="0;url=#{$SERVER}:#{$PORT}/items?show_id=#{id}"></head><body></body></html>~

end
end #Class SaveItems


##################################################################
# BULKUPDATE
#
##################################################################
class BulkUpdate < WEBrick::HTTPServlet::AbstractServlet

  attr_accessor :form

  #prepare class for either get or post requests
  def do_GET(request, response)
    status, content_type, body = bulk_update(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def do_POST(request, response)
    status, content_type, body = bulk_update(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def bulk_update(request)

    $body = String.new()
    update_items = Array.new()
    update_fields = Hash.new()

    request.query.each do | field_filter, value |

      field = field_filter.gsub('_filter','')

      if field.match(/^\d+$/) && field.to_i == value.to_i then
        update_items << value.to_i
      else
        if value != nil && value != '' then
          update_fields[field] = value
        end #if ! nil
      end
    end #request.foreach

    #no reason to continue if there are no update values
    if update_fields.length == 0 then
      return 200, "text/html", %Q~<!DOCTYPE html><html lang="en"><head>
      <link rel="stylesheet" type="text/css" href="../application_styles/application.css" />
      <link rel="stylesheet" type="text/css" href="../application_styles/report.css" />
      <title>#{$APPLICATION_NAME} BULK UPDATE</title>
      </head>
      <body><h2>No field values provided for update<span style="width:100%;color:#8A8370;font-size:9pt;">close browser tab if finshed | click browser back to return to bulk update</span></h2>
      </body></html>~
    end

    #update the fields with new values
    update_items.each do | id |
      update_fields.each do | field_name, value |
          $body << %Q~<tr><td>#{id}</td><td>#{$collection.items[id].name}</td><td>#{field_name}</td><td>#{value}</td></tr>~
          $collection.items[id].instance_variable_set("@#{field_name}", value.to_s)
      end #field value

      $collection.add($collection.items[id])

    end #update_items.each

    #return a page showing the updated fields and values
    return 200, "text/html", %Q~<!DOCTYPE html><html lang="en"><head>
    <link rel="stylesheet" type="text/css" href="../application_styles/application.css" />
    <link rel="stylesheet" type="text/css" href="../application_styles/report.css" />
    <title>#{$APPLICATION_NAME} BULK UPDATE</title>
    </head>
    <body><h2>Bulk Update Results<span style="width:100%;color:#8A8370;font-size:9pt;">close browser tab if finshed | click browser back to return to bulk update</span></h2>
      <table id='report'><tr><th>item id</th><th>item name</th><th>field</th><th>new value</th></tr>
        #{$body}
      </table>
    </body></html>~
  end #bulk_update



###################################################
  def self.form(header_row, report_row_formatted)

    #get the field names from a new blank item object
    bulk_update_fields = String.new()

    row = Item.new()
    row.instance_variables.sort.each do |var|
      value, display = var.to_s, var.to_s

      #skip over the id and added fields; id is a unique record identifier,
      #added is last modified date-time
      next if var.match(/^@id|@added$/)

      type = 'text'
      #give acquired and completed input boxes calendar widget
      if var.match(/^@acquired|@completed$/) then
        type = 'date'
      end
      #give quantity and number_bases input boxes number type drop down
      if var.match(/^@quantity|@number_bases$/) then
        type = 'number'
      end

      #clean up the instance variable names
      value.gsub!(/@/,'')
      display.gsub!(/@/,'')
      display.gsub!(/_/,' ')

      #create the html table rows with field names and text boxes
      bulk_update_fields << %Q~<span style="display:inline-block;width:10em;">#{display}</span><span><input type='#{type}' id='#{value}_filter' name='#{value}_filter' /></span><br />~
    end #each instance_variables


    #return the html bulk update form
    return %Q~<!DOCTYPE html><html lang="en">
<head>
  <link rel="stylesheet" type="text/css" href="../application_styles/application.css" />
  <link rel="stylesheet" type="text/css" href="../application_styles/report.css" />

  <script type="text/javascript">
  //used to fill in edit form from picklists
  function fill_form_field(form_field, form_value)
  {
    document.getElementById(form_field).value=form_value;
  }


  </script>
  <title>#{$APPLICATION_NAME} BULK UPDATE</title>
</head>
<body>
      <form id='bulk_update' name='bulk_update' action='/bulk_update' method='post'>
        <div id='update_fields' name='update_fields' style='width:25%; float:left;'><h2>Bulk Update Fields</h2>
          <input type='submit' value="UPDATE ALL" /><br />
          #{bulk_update_fields}
        </div>

        <div id='update_list' name='update_list' style='width:75%; float:right;'>
          <div id='button_items' class="collapsible" >&#8227; view selected items</div>
          <div id='item_list' class="attributes" style="overflow:auto;">
            <table id='report' id='report' style="width:100%;">
              <tr><th>Update</th><th>#{header_row.join("</th><th>")}</th></tr>
              #{report_row_formatted}
            </table>
          </div>
      </form>

          <div id="menu" class="menu" style="width:100%;">
            #{Menu.new('QUERY',$PICKLISTS).html}
          </div>
    </div>

  #{Collapsible_javascript.new.script}

  <!-- INIT ON PAGE LOAD -->
  <script>
    window.addEventListener("DOMContentLoaded", function(){slist("sortlist");});
  </script>

</body></html>~

  end #of form



end #Class BulkUpdate







##################################################################
# Chart
#
##################################################################
class Chart < WEBrick::HTTPServlet::AbstractServlet

  attr_accessor :display

  #prepare class for either get or post requests
  def do_GET(request, response)
    status, content_type, body = bulk_update(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def do_POST(request, response)
    status, content_type, body = bulk_update(request)
    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  #returns link to manage item for a given id:
  def self.link_id(id)

    return %Q~<a href="#{$SERVER}:#{$PORT}/manage_item?id=#{id}" target="_blank">#{id}</a>~

  end #link_id


  #########################################################################################
  # DISPLAY
  #Determines chart type and creates plotly Javascript
  def self.display(subset_ids, query, report_type, chart_qty)

    chart_fields = Array.new()

    #find out which fields are included by checking the order value. If it has
    #a value then it is to be plotted. Pie and simple Bar charts take a single field
    query.each do | field |
      if field[1]['order'] then
        i = field[1]['order'].to_i - 1
        chart_fields[i] = field[1]['name']
      end
    end

    #make sure the correct number of data fields have been submitted
    case report_type
      when "pie", "bar"
        if chart_fields[0] == 0 or chart_fields[0] == nil then
          details = "<h3>Pie and Bar charts require a field in order 1. Please try again.</h3>"
          return html_output('', '', details, '', '', '')
        end
      when "bar-grouped", "bar-stacked"
        if chart_fields[0] == 0 or chart_fields[0] == nil or chart_fields[1] == 0 or chart_fields[1] == nil then
          details =  "<h3>Grouped Bar and Stacked Bar charts require two fields in orders 1 and 2. Please try again.</h3>"
          return html_output('', '', details, '', '', '')
      end
    end #end case statement

    $body = String.new()

    #Plotly attributes
    data = String.new()
    layout = String.new()
    traces = String.new()
    #detail table following chart
    details = String.new()
    detail_header_row = String.new()
    total_count = 0
    #default to counting records unless summing quantity selected by user
    count_of = chart_qty ? 'Quantity' : 'Records'
    #fields selected by user to chart
    sort_fields = Array.new()
    primary_field = Hash.new() #is used for x axis (horizontal)
    secondary_field = Hash.new() #is used for y axis (vertical)

    colorway = ['#183a0a','#1c552a','#18714d','#068f74','#00ada0','#00cbce','#00e9ff','#00d0f9','#00b6f0','#009de3','#0083d1','#2f68bb','#474da0']

    #extra color groupings used in timeline chart
    colors = {
      'greens' => ['rgb(0, 255, 255)','rgb(127, 255, 212)','rgb(69, 75, 27)','rgb(8, 143, 143)','rgb(170, 255, 0)','rgb(95, 158, 160)','rgb(9, 121, 105)','rgb(175, 225, 175)','rgb(223, 255, 0)','rgb(228, 208, 10)','rgb(0, 255, 255)','rgb(2, 48, 32)','rgb(125, 249, 255)','rgb(80, 200, 120)','rgb(95, 133, 117)','rgb(79, 121, 66)','rgb(34, 139, 34)','rgb(124, 252, 0)','rgb(0, 128, 0)','rgb(53, 94, 59)','rgb(0, 163, 108)','rgb(42, 170, 138)','rgb(76, 187, 23)','rgb(144, 238, 144)','rgb(50, 205, 50)','rgb(71, 135, 120)','rgb(11, 218, 81)','rgb(152, 251, 152)','rgb(138, 154, 91)','rgb(15, 255, 80)','rgb(236, 255, 220)','rgb(128, 128, 0)','rgb(193, 225, 193)','rgb(201, 204, 63)','rgb(180, 196, 36)','rgb(147, 197, 114)','rgb(150, 222, 209)','rgb(138, 154, 91)','rgb(46, 139, 87)','rgb(159, 226, 191)','rgb(0, 158, 96)','rgb(0, 255, 127)','rgb(0, 128, 128)','rgb(64, 224, 208)','rgb(196, 180, 84)','rgb(64, 181, 173)','rgb(64, 130, 109)'],
      'blues' => ['rgb(0, 255, 255)','rgb(240, 255, 255)','rgb(137, 207, 240)','rgb(0, 0, 255)','rgb(115, 147, 179)','rgb(8, 143, 143)','rgb(0, 150, 255)','rgb(95, 158, 160)','rgb(0, 71, 171)','rgb(100, 149, 237)','rgb(0, 255, 255)','rgb(0, 0, 139)','rgb(111, 143, 175)','rgb(20, 52, 164)','rgb(125, 249, 255)','rgb(96, 130, 182)','rgb(0, 163, 108)','rgb(63, 0, 255)','rgb(93, 63, 211)','rgb(173, 216, 230)','rgb(25, 25, 112)','rgb(0, 0, 128)','rgb(31, 81, 255)','rgb(167, 199, 231)','rgb(204, 204, 255)','rgb(182, 208, 226)','rgb(150, 222, 209)','rgb(65, 105, 225)','rgb(15, 82, 186)','rgb(159, 226, 191)','rgb(135, 206, 235)','rgb(70, 130, 180)''rgb(0, 128, 128)','rgb(64, 224, 208)','rgb(4, 55, 242)','rgb(64, 181, 173)','rgb(8, 24, 168)'],
      'yellows' => ['rgb(234, 221, 202)','rgb(255, 191, 0)','rgb(251, 206, 177)','rgb(245, 245, 220)','rgb(225, 193, 110)','rgb(255, 234, 0)','rgb(253, 218, 13)','rgb(255, 255, 143)','rgb(223, 255, 0)','rgb(228, 208, 10)','rgb(255, 248, 220)','rgb(255, 253, 208)','rgb(139, 128, 0)','rgb(250, 213, 165)','rgb(194, 178, 128)','rgb(238, 220, 130)','rgb(228, 155, 15)','rgb(255, 215, 0)','rgb(255, 192, 0)','rgb(218, 165, 32)','rgb(252, 245, 95)','rgb(255, 255, 240)','rgb(248, 222, 126)','rgb(240, 230, 140)','rgb(250, 250, 51)','rgb(251, 236, 93)','rgb(244, 187, 68)','rgb(255, 219, 88)','rgb(250, 218, 94)','rgb(255, 222, 173)','rgb(236, 255, 220)','rgb(255, 250, 160)','rgb(255, 229, 180)','rgb(201, 204, 63)','rgb(180, 196, 36)','rgb(147, 197, 114)','rgb(244, 196, 48)','rgb(243, 229, 171)','rgb(196, 180, 84)','rgb(245, 222, 179)','rgb(255, 255, 0)','rgb(255, 170, 51)'],
      'whites' => ['rgb(237, 234, 222)','rgb(245, 245, 220)','rgb(249, 246, 238)','rgb(255, 248, 220)','rgb(255, 253, 208)','rgb(240, 234, 214)','rgb(255, 255, 240)','rgb(233, 220, 201)','rgb(255, 222, 173)','rgb(250, 249, 246)','rgb(252, 245, 229)','rgb(255, 229, 180)','rgb(226, 223, 210)','rgb(255, 245, 238)','rgb(243, 229, 171)','rgb(255, 255, 255)'],
      'reds' => ['rgb(136, 8, 8)','rgb(170, 74, 68)','rgb(238, 75, 43)','rgb(165, 42, 42)','rgb(128, 0, 32)','rgb(110, 38, 14)','rgb(204, 85, 0)','rgb(233, 116, 81)','rgb(112, 41, 99)','rgb(210, 43, 43)','rgb(196, 30, 58)','rgb(215, 0, 64)','rgb(222, 49, 99)','rgb(210, 4, 45)','rgb(149, 69, 53)','rgb(129, 19, 49)','rgb(248, 131, 121)','rgb(129, 65, 65)','rgb(220, 20, 60)','rgb(139, 0, 0)','rgb(123, 24, 24)','rgb(154, 42, 42)','rgb(192, 64, 0)','rgb(128, 0, 0)','rgb(152, 104, 104)','rgb(119, 7, 55)','rgb(255, 49, 49)','rgb(74, 4, 4)','rgb(250, 160, 160)','rgb(236, 88, 0)','rgb(227, 83, 53)','rgb(169, 92, 104)','rgb(227, 11, 92)','rgb(255, 0, 0)','rgb(165, 42, 42)','rgb(145, 56, 49)','rgb(255, 68, 51)','rgb(149, 53, 83)','rgb(194, 30, 86)','rgb(224, 17, 95)','rgb(128, 70, 27)','rgb(250, 128, 114)','rgb(255, 36, 0)','rgb(250, 95, 85)','rgb(227, 115, 94)','rgb(124, 48, 48)','rgb(99, 3, 48)','rgb(164, 42, 4)','rgb(227, 66, 52)','rgb(114, 47, 55)'],
      'purples' => ['rgb(159, 43, 104)','rgb(191, 64, 191)','rgb(128, 0, 32)','rgb(112, 41, 99)','rgb(170, 51, 106)','rgb(48, 25, 52)','rgb(72, 50, 72)','rgb(93, 63, 211)','rgb(230, 230, 250)','rgb(203, 195, 227)','rgb(207, 159, 255)','rgb(170, 152, 169)','rgb(224, 176, 255)','rgb(145, 95, 109)','rgb(119, 7, 55)','rgb(218, 112, 214)','rgb(195, 177, 225)','rgb(204, 204, 255)','rgb(103, 49, 71)','rgb(169, 92, 104)','rgb(128, 0, 128)','rgb(81, 65, 79)','rgb(149, 53, 83)','rgb(216, 191, 216)','rgb(99, 3, 48)','rgb(127, 0, 255)','rgb(114, 47, 55)','rgb(189, 181, 213)'],
      'pinks' => ['rgb(159, 43, 104)','rgb(242, 210, 189)','rgb(222, 49, 99)','rgb(129, 19, 49)','rgb(255, 127, 80)','rgb(248, 131, 121)','rgb(220, 20, 60)','rgb(170, 51, 106)','rgb(201, 169, 166)','rgb(255, 0, 255)','rgb(255, 105, 180)','rgb(255, 182, 193)','rgb(255, 0, 255)','rgb(243, 207, 198)','rgb(119, 7, 55)','rgb(255, 16, 240)','rgb(218, 112, 214)','rgb(248, 200, 220)','rgb(250, 160, 160)','rgb(255, 192, 203)','rgb(248, 152, 128)','rgb(103, 49, 71)','rgb(169, 92, 104)','rgb(128, 0, 128)','rgb(227, 11, 92)','rgb(149, 53, 83)','rgb(243, 58, 106)','rgb(224, 191, 184)','rgb(194, 30, 86)','rgb(224, 17, 95)','rgb(250, 128, 114)','rgb(255, 245, 238)','rgb(216, 191, 216)','rgb(227, 115, 131)'],
      'oranges' => ['rgb(255, 191, 0)','rgb(251, 206, 177)','rgb(242, 210, 189)','rgb(255, 172, 28)','rgb(205, 127, 50)','rgb(218, 160, 109)','rgb(204, 85, 0)','rgb(233, 116, 81)','rgb(227, 150, 62)','rgb(242, 140, 40)','rgb(210, 125, 45)','rgb(184, 115, 51)','rgb(255, 127, 80)','rgb(248, 131, 121)','rgb(139, 64, 0)','rgb(250, 213, 165)','rgb(228, 155, 15)','rgb(255, 192, 0)','rgb(218, 165, 32)','rgb(255, 213, 128)','rgb(192, 64, 0)','rgb(244, 187, 68)','rgb(255, 222, 173)','rgb(255, 95, 31)','rgb(204, 119, 34)','rgb(255, 165, 0)','rgb(250, 200, 152)','rgb(255, 229, 180)','rgb(236, 88, 0)','rgb(248, 152, 128)','rgb(227, 83, 53)','rgb(255, 117, 24)','rgb(255, 68, 51)','rgb(255, 95, 21)','rgb(250, 128, 114)','rgb(255, 245, 238)','rgb(160, 82, 45)','rgb(250, 95, 85)','rgb(240, 128, 0)','rgb(227, 115, 94)','rgb(255, 170, 51)'],
      'grays' => ['rgb(178, 190, 181)','rgb(115, 147, 179)','rgb(54, 69, 79)','rgb(169, 169, 169)','rgb(96, 130, 182)','rgb(128, 128, 128)','rgb(129, 133, 137)','rgb(211, 211, 211)','rgb(137, 148, 153)','rgb(229, 228, 226)','rgb(138, 154, 91)','rgb(192, 192, 192)','rgb(112, 128, 144)','rgb(132, 136, 132)','rgb(113, 121, 126)'],
      'browns' => ['rgb(234, 221, 202)','rgb(225, 193, 110)','rgb(205, 127, 50)','rgb(165, 42, 42)','rgb(218, 160, 109)','rgb(128, 0, 32)','rgb(233, 116, 81)','rgb(110, 38, 14)','rgb(193, 154, 107)','rgb(149, 69, 53)','rgb(123, 63, 0)','rgb(210, 125, 45)','rgb(111, 78, 55)','rgb(131, 67, 51)','rgb(184, 115, 51)','rgb(129, 65, 65)','rgb(92, 64, 51)','rgb(139, 0, 0)','rgb(152, 133, 88)','rgb(194, 178, 128)','rgb(193, 154, 107)','rgb(229, 170, 112)','rgb(154, 42, 42)','rgb(150, 105, 25)','rgb(240, 230, 140)','rgb(196, 164, 132)','rgb(192, 64, 0)','rgb(128, 0, 0)','rgb(150, 121, 105)','rgb(242, 210, 189)','rgb(204, 119, 34)','rgb(128, 128, 0)','rgb(74, 4, 4)','rgb(169, 92, 104)','rgb(165, 42, 42)','rgb(145, 56, 49)','rgb(128, 70, 27)','rgb(139, 69, 19)','rgb(194, 178, 128)','rgb(160, 82, 45)','rgb(210, 180, 140)','rgb(72, 60, 50)','rgb(124, 48, 48)','rgb(245, 222, 179)','rgb(114, 47, 55)'],
      'blacks' => ['rgb(0, 0, 0)','rgb(54, 69, 79)','rgb(2, 48, 32)','rgb(48, 25, 52)','rgb(52, 52, 52)','rgb(27, 18, 18)','rgb(40, 40, 43)','rgb(25, 25, 112)','rgb(53, 57, 53)']
    }




############################################  PIE/ SIMPLE BAR BAR ######################################
  if report_type.match(/^pie|bar$/) then

    #hash for storing colors indexed with chart_field[0] values used to assign color to detail records
    detail_color = Hash.new()
    i = 0 #used to assign above to colorway values

#chart_fields[0]
#    sort_fields = Array.new()
#    sort_fields[0] = 'completed'
#    subset_ids = $collection.sort(subset_ids, sort_fields)


    #loop through the ids supplied by the report function
    subset_ids.each do | key |

      #find a color for the detail row
      if !detail_color.has_key?($collection.items[key].instance_eval(chart_fields[0])) then
        detail_color[$collection.items[key].instance_eval(chart_fields[0])] = colorway[i]
        i = i+1
        if i > colorway.length then i = 0 end
      end

      #are we counting records or summing quantity? if records, default to 1 for each record; if quantity, some quantity field of record
      qty = 1
      if chart_qty != '' and chart_qty != nil then
        qty = $collection.items[key].quantity ? $collection.items[key].quantity : 1
      end

      #find items which match the value of the first (and only for pie/bar chart) column
      primary_field[$collection.items[key].instance_eval(chart_fields[0]).to_s] = primary_field[$collection.items[key].instance_eval(chart_fields[0]).to_s].to_i + qty.to_i

      total_count += qty.to_i
      #populate a row for the detail table displayed beneath the chart
      details << %Q~<tr>
        <td>#{link_id($collection.items[key].id)}</td>
        <td>#{qty}</td><td>#{$collection.items[key].name}</td>
        <td><span class='textshadow' style="color:#{detail_color[$collection.items[key].instance_eval(chart_fields[0])]};">
            #{$collection.items[key].instance_eval(chart_fields[0])}
            </span>
        </td>
      </tr>~

    end #each subset_id

    #assign values to the plotly value and label data variables
    labels = Array.new()
    values = Array.new()

    #assign chart_field names and values to plotly vars for labels and values
    primary_field.each do | key, value |
        labels << "#{key}"
        values << "#{value}"
    end #of primary_field processing

    #map null values to something more sensible for the user
    labels.map!{ | m | if m.match(/^$/) then '??' else m end }
    values.map!{ | m | if m.match(/^$/) then '0' else m end }

    #slightly different plotly javascript data between pie and simple bar charts
    if report_type == 'pie' then
      data << %Q~
      var xValues = ['#{labels.join("','")}'];
      var yValues = [#{values.join(",")}];
      var data = [{
          labels: xValues,
          values: yValues,
          type: '#{report_type}',
          rotation: -30
          }];\n~
    elsif report_type == 'bar' then
      data << %Q~
      var xValues = ['#{labels.join("','")}'];
      var yValues = [#{values.join(",")}];
      var data = [{
              x: xValues,
              y: yValues,
              marker: {color: ["#{detail_color.values.join('","')}"]},
              type: '#{report_type}',
              text: yValues.map(String),
              textposition: 'auto'
            }];\n~
    end #report_type pie or bar plotly data

    #layout section of plotly data
    layout = %Q~var layout = {colorway : #{colorway},
            title: '#{chart_fields[0]}',
            paper_bgcolor: 'rgb(0,0,0,0)',
            plot_bgcolor: 'rgb(0,0,0,0)',
            legend: {bgcolor: 'rgba(0,0,0,0)', title:{ text:'#{chart_fields[0].to_s}'}},
            autosize: true,
            yaxis: {
                automargin: true
              }
          };~

    #header row for the detail listing of records
    detail_header_row = %Q~<tr>
      <th>ID</th>
      <th>#{count_of} #{total_count}</th>
      <th>Name</th>
      <th>#{chart_fields[0]}</th>
    </tr>~




#puts "###########################################  STACKED/GROUPED BAR ######################################"
  elsif report_type.match(/^bar-grouped|bar-stacked$/) then

    detail_color = Hash.new()
    i = 0

    #what type of bar chart are we making?
    case report_type
    when "bar-grouped"
        barmode = "group"
    when "bar-stacked"
        barmode = "stack"
    end

    #primary field used for x axis (horizontal), secondary_field becomes the y axis (vertical)
    values = Hash.new()

    #count the number of records with charted attribute
    subset_ids.each do | key |

      #are we counting records or summing the quantity?
      qty = 1
      if chart_qty != '' and chart_qty != nil then
        qty = $collection.items[key].quantity ? $collection.items[key].quantity : 1
      end

      primary_field[$collection.items[key].instance_eval(chart_fields[0]).to_s] = primary_field[$collection.items[key].instance_eval(chart_fields[0]).to_s].to_i + qty.to_i
      secondary_field[$collection.items[key].instance_eval(chart_fields[1].to_s)] = secondary_field[$collection.items[key].instance_eval(chart_fields[1].to_s)].to_i + qty.to_i

      if chart_fields[1].to_s == $collection.items[key].instance_eval(chart_fields[1]).to_s then
          secondary_field[chart_fields[1].to_s] = secondary_field[chart_fields[1].to_s].to_i + qty.to_i
      end

      #increase the total count for the detail report
      total_count += qty.to_i

      #find a color for the detail row
      if !detail_color.has_key?($collection.items[key].instance_eval(chart_fields[1])) then
        detail_color[$collection.items[key].instance_eval(chart_fields[1])] = colorway[i]
        i = i+1
        if i > colorway.length then i = 0 end
      end

      #add the row to the detail report
      details << %Q~<tr><td>#{link_id($collection.items[key].id)}</td><td>#{qty}</td><td>#{$collection.items[key].name}</td><td>#{$collection.items[key].instance_eval(chart_fields[0])}</td>
      <td>
        <span class='textshadow' style="color:#{detail_color[$collection.items[key].instance_eval(chart_fields[1])]};">
          #{$collection.items[key].instance_eval(chart_fields[1])}
        </span>
      </td></tr>~
    end #of subset id

    labels = String.new()
    traces = String.new()
    secondary_values = Hash.new()

    secondary_field.each do | key, value |

      value_string = values[key]
      value_string = "#{value_string} '#{value.to_s}',"

      secondary_values[key] = Hash.new()

      values[key] = value_string

    end #of secondary_field keys

    subset_ids.each do | key |

      #are we counting records or summing the quantity? AGAIN!
      qty = 1
      if chart_qty != '' and chart_qty != nil then
        qty = $collection.items[key].quantity ? $collection.items[key].quantity : 1
      end

      primary_field_name = $collection.items[key].instance_eval(chart_fields[0]).to_s
      secondary_field_name = $collection.items[key].instance_eval(chart_fields[1]).to_s
      secondary_values[secondary_field_name][primary_field_name] = secondary_values[secondary_field_name][primary_field_name].to_i + qty.to_i

    end #subset_ids.each

    i = 0
    xvalues = Array.new(primary_field.keys)
    yvalues = Array.new(xvalues.length, '0')

    secondary_values.each do | key, value |

      s = 0
      xvalues.each do | p |
        yvalues[s] = !secondary_values[key][p] ? '0' : secondary_values[key][p]
        s = s+1
      end

      #substitue ?? for null values in xvalues and name
      xvalues.map!{ | m | if m.match(/^$/) then '??' else m end }
      if key == '' || key == nil then key = '??' end

      traces << %Q~\nvar xValues = ['#{xvalues.join("','")}'];
                 \nvar yValues = [#{yvalues.join(",")}];
                 \nvar trace#{i} = {x: xValues,
                                    y: yValues,
                                    name: '#{key}',
                                    type: 'bar',
                                    text: yValues.map(String),
                                    textposition: 'auto'
                                   };
                 ~
      #reset null values to null to match next record with null values in secondary fields
      # (must be a better way to do this!)
      xvalues.map!{ | m | if m.match(/\?\?/) then '' else m end }

      data << "trace#{i},"
      i = i + 1
    end #of secondary_field each

    data = "var data = [#{data}]"

    layout = %Q~var layout = {colorway: #{colorway},
              title: '#{chart_fields.join(", ")}',
              paper_bgcolor: 'rgb(0,0,0,0)',
              plot_bgcolor: 'rgb(0,0,0,0)',
              showlegend: true,
              legend: {bgcolor: 'rgba(0,0,0,0)', title:{ text:'#{chart_fields[1].to_s}'}},
              xaxis: {title: '#{chart_fields[0].to_s}'},
              barmode: '#{barmode}',
              autosize: true,
              automargin: true

              };~

    detail_header_row = %Q~<tr>
      <th>ID</th>
      <th>#{count_of} #{total_count}</th>
      <th>Name</th>
      <th>#{chart_fields[0]}</th>
      <th>#{chart_fields[1]}</th>
    </tr>~



#puts "###########################################  TIMELINE ######################################"
  elsif report_type.match(/^timeline$/) then

    completions = Array.new()
    completion_dates = Array.new()
    complete_hash = Hash.new()

    acquisitions = Array.new()
    acquisition_dates = Array.new()
    acquisition_hash = Hash.new()

    acq_count = 0
    com_count = 0

    #random color for each genre keyed to genre
    color_hash = Hash.new()

    subset_ids.each do | key|
      #create a hash of hashes; first key is genre
      complete_hash[$collection.items[key].genre] = Hash.new()
      acquisition_hash[$collection.items[key].genre] = Hash.new()

      #making sure genres in both completed and acquired use the same color
      color_hash[$collection.items[key].genre] = (colors['reds'] + colors['yellows'] + colors['blues']).sample
#      color_hash[$collection.items[key].genre] = colors.flatten.sample
  end


    subset_ids.each do | key |
      #flag to indicate whether to add the record to the detail lising
      add_to_detail = ''
      qty = 1 #default to 1... mostly to account for acquisitions that do not have a quantity listed
      if $collection.items[key].quantity.to_i > 0 then qty = $collection.items[key].quantity.to_i end

      if $collection.items[key].acquired == '' then $collection.items[key].acquired = '2018-01-01' end

      #populate the acquisition hash of hashes keyed by date of completion/acquistion
      if $collection.items[key].acquired != '' then
        #increment the hash[genre][acquistion-date] count/quantity
        acquisition_hash[$collection.items[key].genre][$collection.items[key].acquired] = acquisition_hash[$collection.items[key].genre][$collection.items[key].acquired].to_i + qty
        add_to_detail = 'Y'
        acq_count = acq_count + qty
      end
      #populate the completion hash of hashes keyed by date of completion/acquistion
      if $collection.items[key].completed != '' then
        #increment the hash[genre][completion-date] count/quantity
        complete_hash[$collection.items[key].genre][$collection.items[key].completed] = complete_hash[$collection.items[key].genre][$collection.items[key].completed].to_i + qty
        add_to_detail = 'Y'
        com_count = com_count + qty
      end

      #if we added the record to the aquisicion/completed plots we want to add it to the detail listing
      if add_to_detail == 'Y' then details << %Q~<tr>
          <td>#{link_id($collection.items[key].id)}</td>
          <td>#{$collection.items[key].quantity}</td>
          <td>#{$collection.items[key].category}</td>
          <td><span class='textshadow' style="color:#{color_hash[$collection.items[key].genre]};">#{$collection.items[key].genre}</span></td>
          <td>#{$collection.items[key].name}</td>
          <td>#{$collection.items[key].acquired}</td>
          <td>#{$collection.items[key].completed}</td>
        </tr>~ end

    end #subset_ids.each

    trace_list = Array.new()
    traces = String.new()
    i = 0

    #create the completion traces for plotly
    complete_hash.each do |genre, comp_hash|
      all_dates = Array.new()
      all_qty = Array.new()
      var_name = "trace#{i}"
      i=i+1

      comp_hash.each do | date, quantity|
        all_dates << date
        all_qty << quantity
      end #end comp_hash date

      if all_qty.length != 0 then
        trace_list << var_name
        traces << %Q~var #{var_name} = {
          type: "scatter",
          mode: "markers",
          name: '#{genre} (C)',
          x: ['#{all_dates.join("','")}'],
          y: [#{all_qty.join(',')}],
          legendgroup: '#{genre}',
          marker: {
            color: '#{color_hash[genre]}',
            size: 10,
            line: {color: 'grey',
            width: 1}
          }
          };~
      end #end if all_qty
    end #end complete_hash genre

    #create the acquisition traces for plotly
    acquisition_hash.each do |genre, acq_hash|
      all_dates = Array.new()
      all_qty = Array.new()
      var_name = "trace#{i}"
      i=i+1

      acq_hash.each do | date, quantity|
        all_dates << date
        all_qty << quantity
      end

      if all_qty.length != 0 then
        trace_list << var_name
        traces << %Q~var #{var_name} = {
          type: "scatter",
          mode: "markers",
          name: '#{genre} (A)',
          x: ['#{all_dates.join("','")}'],
          y: [#{all_qty.join(',')}],
          legendgroup: '#{genre}',
          marker: {
            color: '#{color_hash[genre]}',
            size: 10,
            symbol: "cross",
            line: {color: 'grey',
            width: 1}
          }
        };~
      end
    end #end acquistion_hash genre

    #trace list for plotly data variable
    data = "var data = [#{trace_list.join(",")}];"

    #layout var for plotly
    layout = %Q~var layout = {colorway: #{colorway},
              title: 'Timeline',
              paper_bgcolor: 'rgb(0,0,0,0)',
              plot_bgcolor: 'rgb(0,0,0,0)',
              showlegend: true,
              legend: {bgcolor: 'rgba(0,0,0,0)', title:{ text:'Action'}},
              autosize: true,
              automargin: true
              };~

    #detail report header row for timeline is slightly different than other chart types
    detail_header_row = %Q~<tr>
      <th>ID</th>
      <th>Quantity</th>
      <th>Category</th>
      <th>Genre</th>
      <th>Name</th>
      <th>Acquired (#{acq_count})</th>
      <th>Completed (#{com_count})</th>
    </tr>~

  end #of timeline chart type

#pass whatever chart has been created to html_output
  return html_output(report_type, detail_header_row, details, traces, data, layout)
end #display


#########################################################################################
# HTML_OUTPUT
#HTML code page that displays plotly charts
def self.html_output (report_type, detail_header_row, details, traces, data, layout)
    #return a page showing the updated fields and values
    chart = %Q~<!DOCTYPE html><html lang="en"><head>
    <link rel="stylesheet" type="text/css" href="../application_styles/application.css" />
    <link rel="stylesheet" type="text/css" href="../application_styles/report.css" />
    <link rel="stylesheet" href="../sortable/sortable-theme-minimal.css" />
	<script src='../plotly/plotly-2.20.0.min.js'></script>
  <script src='../sortable/sortable.js'></script>
  <style>
    .textshadow {text-shadow: -1px 1px 1px #bbb, 1px 2px 1px #bbb,  1px -1px 0 #bbb,  -1px -1px 0 #bbb; }
  </style>
  <title>#{$APPLICATION_NAME} #{report_type.capitalize} Chart</title>
  </head>
  <body><h2>#{report_type.capitalize} Chart <span style="width:100%;color:#8A8370;font-size:9pt;"> (close browser tab when finshed to return to Query)</span></h2>
	 <div id='Chart' style='width:95%;height:auto;'><!-- Plotly chart will be drawn inside this DIV --></div>
   <div>
      <table class="sortable-theme-minimal" data-sortable id='report'>
        <thead>#{detail_header_row}</thead>
        <tbody>#{details}</tbody>
     </table>
   </div>
  </body>
  <script>
    #{traces}
    #{data}
    #{layout}

    var config = {responsive: true};

    Plotly.newPlot('Chart', data, layout, config);
  </script>

  </html>~

  return chart
end #html_output

end #Class Chart








##################################################################
# EXIT
#
##################################################################
class Quit < WEBrick::HTTPServlet::AbstractServlet

 def do_GET(request, response)
    puts "shutting down webrick, pid: #{$$}"
    Process.kill 'INT', $$

    puts "saving collection to yaml"
    $collection.save()

    response.status = 200
    response['Content-Type'] = "text/html"

#web page
response.body = %Q~<html>
<head>
<link rel="stylesheet" type="text/css" href="../application_styles/application.css" />
</head>
<body>
<div id="content">
  <h1>#{$APPLICATION_NAME} has been shut down.</h1>
  <h2>You may now close your browser.</h2>
</div>
</body></html>~

  end

end #class Quit





##################################################################
# Collection
#
#
##################################################################
class Collection
attr_accessor :items, :select, :sort

  def initialize()

    @items = Hash.new

    if File.file?("application_items.yml")
      #read the yaml file into the collection
      self.items = YAML.load(File.read("application_items.yml"))
    else
      puts "yaml file does not exist!!!"
      puts"saving new empty yaml file"
      self.save()
    end

  end #initialize




  def add(item)

#puts "ITEM ID RECIEVED: '#{item.id}'"
    #if no item.id is included then it is a new item and needs a new collection item.id number
    if !item.id || item.id == nil || item.id == '' || item.id.to_s.match(/^\D+$/) then
#     if !item.id.is_a?(Integer) #negated by !
      min, max = @items.keys.minmax
      next_key = max.to_i + 1
      item.id = next_key.to_s
#          puts "NEW ITEM ID NEEDED"
    end
    #update the added field to the current date
    item.added = Time.now.to_s

#puts ">>>>> ITEM ID: #{item.id} <<<<<<"


    #add or update the item in the collection@items
   @items[item.id.to_i] = item
   self.save()
#      puts "UPDATED ITEM"

  end #add




  #delete an item from the collection (note id is numeric, not a string.
  def delete(id)
   gone = @items.delete(id.to_i)
   self.save()
#   puts "deleted item #{gone}"
  end #delete





  #save the yaml file to disk, application_items.yml is default, other file names can be passed in
  def save(file_name='application_items.yml')
   #open output file, write the yaml, close the file
   f = File.open(file_name, "w")
   f.write(@items.to_yaml)
   f.close
  end #save





 #Return a subset of collection containing the desired value in the desired field
def select(field, term, scope)
  if field.to_s.empty? || field.to_s == '' || field == nil then field = 'id' end
  if term.to_s.empty?  || field.to_s == '' || field == nil then term = '\d' end
  if scope != 'exact'  then scope = 'contains' end

  #check to see if there are alternate values supplied (separated by '~'). This works in both the simply search and the advanced query
  terms = term.split('~')

  #this is the hash to contain selected records using the object id as the key
  subset = {}

  #loop through the collection pulling only those records that have the desired value in the desired field
  @items.each do | key, item |

    #the following each loop allows multiple values in the same field to be used. Separate query values with '~'
    terms.each do |match_term|
      #are we matching in ANY field?
      if field == 'any' then
        #loop through item fields
        item.instance_variables.each do | field_name |
          if item.instance_eval(field_name.to_s).to_s.match(/#{match_term}/i) then
            subset[key] = item
          end
        end
      #if the record has the desired value in the field...
      elsif scope == 'exact' && item.instance_eval(field).to_s.match(/^#{match_term}$/i) then
        subset[key] = item
      elsif scope == 'contains' && item.instance_eval(field).to_s.match(/#{match_term}/i) then
        subset[key] = item
      end #if scope
    end #terms.each match_term do
  end #@items. each do key, item

  #finally return a subset of ONLY those items that match the search criteria
  #The entire item object is returned because we will need it for the order function if the order is not by the searched field
  return subset
end #select





#return an array of the ids of the subset sorted by the values in the desired field
def sort(subset,fields)
  sorted = []
  sorted_ids = []

  #a temp structure containing just the ids and field values
  sort_stuff = Struct.new(:id, :value)

  #populate an array containing just the ids and the desired field values for sorting
  subset.each do | key, item |

    values = String.new
    if fields == 'age' then
       age = DateTime.now - DateTime.parse(item.added)
       values << (age * 24 * 60 * 60).to_i.to_s
    else
     fields.each do |field_name|
     next if field_name.to_s == ''  #defend against nil values in the field_name array
       #put numerics into proper order - to avoid '1' being sorted after '10', etc
       numeric = 1000000 #final sort is done on strings, so numeric values need to be padded to ensure that all digits have the same string length
       if item.instance_eval(field_name).to_s.match(/^\d+\.?\d*$/) then #note: example 1.2.3 will be sorted as string, not numeric
         numeric = numeric + item.instance_eval(field_name).to_f
         values << numeric.to_s
       else
       #form a string to use in the sorting operation
         values << item.instance_eval(field_name).to_s
       end #if item
     end #fields.each do
   end #if !fields

   sorted << sort_stuff.new(key, values)
  end #subset.each

  #sort the structures by the values of the identified field
  if fields == 'age' then
    final = sorted.sort_by {| item | [item.value.to_i]}
  else
    final = sorted.sort_by {| item | [item.value.downcase]}
  end

  #put just the sorted ids into an array to return to the caller
  final.each do | item |
    sorted_ids << item.id
  end

  #finally return an array that contains simply the sorted ids of the submitted collection
  return sorted_ids
end #sort

end #class Collection


##################################################################
# Item
#
#
##################################################################
class Item < Hash

  attr_accessor  :id,         :description,        :genre,             :tags,               :name,
                 :cost,       :value,              :location,          :acquired,           :added,
                 :notes,      :web,                :icon_image,        :item_image,         :image_dir,
                 #application specific
                 :quantity,     :scale,              :type,              :manufacturer,       :status,
                 :painter,      :completed,          :category,          :number_bases,       :base_size,
                 :rule_system,  :material

  def initialize(id=nil,      description='',      genre='',                 tags='',       name='',
                 cost=0.00,   value=0.00,          location='at large',      acquired='',   added='',
                 notes='',    web='',              icon_image='default.png', item_image='', image_dir='application_images',
                 #application specific
                 quantity='1',       scale='28mm',          type='figures',           manufacturer='none',  status='NIB',
                 painter='',         completed='today',     category='none',          number_bases='1',     base_size='1x1',
                 rule_system='any',  material='plastic')

       #autofill the instance variables with method added to Object class, below
       set_instance_variables(binding, *local_variables)
    end #initialize
end #Item class defination


##############################################################################
#ADD A METHOD TO OBJECT CLASS TO ALLOW AUTOFILL OF CLASS VARIABLES
#See p.351 of Ruby Cookbook, First Edition, July 2006 for explaination
# used by both item and report objects
##############################################################################
class Object
  private
  def set_instance_variables(binding, *variables)
      variables.each do |var|
          instance_variable_set("@#{var}", eval(var.to_s, binding))
      end #each do
  end #set_instance_variables

end #class


##############################################################################
# Dispatcher
#
#
##############################################################################

 #This takes the name of the file, cleans it up, and uses it as the application name throughout the script
 $APPLICATION_NAME = File.basename($0, File.extname($0)).downcase.split(/ |\_|\-/).map(&:capitalize).join(" ")
 $VERSION = 'v.20230610'

 #Navigational menus
 $MENUS     = ['location','genre','rule_system','tags','scale','category','status','manufacturer','type','material','painter','base_size']
 $PICKLISTS = ['genre','tags','category','material','location','rule_system','manufacturer','scale','type','status','base_size','painter']

 if !defined? $collection then
    $collection = Collection.new()
#    puts "creating first run collection"
 end

 if !defined? $report_library then
    $saved_reports = SavedReports.new()
#    puts "creating reports"
 end

 #using https would be good but it is dependent upon the user's environment with SSL and complicates install
  $SERVER = 'http://localhost'
  $PORT = 8500

 if $0 == __FILE__ then

  #mount servlets for various pages/commands
  server = WEBrick::HTTPServer.new(:Port => $PORT,
                                   :DocumentRoot => Dir::pwd,
                                   :SSLEnable => true,
                                   :SSLCertName => $APPLICATION_NAME
                                 )

  server.mount "/items", ShowItems
  server.mount "/manage_item", ManageItems
  server.mount "/save_item", SaveItems
  server.mount "/delete_item", DeleteItem
  server.mount "/query", Query
  server.mount "/query_results", QueryResults
  server.mount "/labels", QueryResults
  server.mount "/quit", Quit
  server.mount "/peek", PeekItem
  server.mount "/bulk_update", BulkUpdate
  server.mount "/chart", Chart

  #open the default browser and load items page
  link = "#{$SERVER}:#{$PORT}/items"
  if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/ then
    system("start #{link}")
  elsif RbConfig::CONFIG['host_os'] =~ /darwin/ then
    system("open #{link}")
  elsif RbConfig::CONFIG['host_os'] =~ /linux/ then
    system("xdg-open #{link}")
  end

  #allow cntl-c to shut down the server
  trap "INT" do server.shutdown end

  #start the web server
  server.start

end #if $0 == __FILE__
