#lecture
using DataFrames
df = DataFrame(A=1:50, B=31:80, fixed=1)
first(df, 3) #shows first three rows
last(df, 3) #shows last three lines
names(df)
show(df, allcols=true) #shows whole dataframe
size(df) #shows number of rows and number of colums (returns a tuble with r,c)
ismissing.(df[!, :A]) #checks for missing values
unique(df[!, :A]) #gives all unique values in a colum (no doubles)
dropmissing(df) #drops rows and colums with missing values
describe(df) #summary of all the rows

Base.bin(UInt(1), 1, false) #binary represantation
Base.bin(UInt(4), 10, false) #adds extra 0 in front

using ScikitLearn
import ScikitLearn: fit!, predict
@sk_import feature_selection: f_regression

@sk_import feature_selection: VarianceThreshold
X = rand(15, 10)
Model = VarianceThreshold(0.05)
X_new = fit_transform!(s, X)



#excercises
#hotel bookings dataframe
using DataFrames
using CSV
f_hotel = "hotel_bookings.csv"
df_hotel = CSV.read(f_hotel, DataFrame)

#take out canceled reservations
df_not_canceled = df_hotel[df_hotel.is_canceled .== 0, :]
#vector of months
months = df_not_canceled.arrival_date_month
#dictionary to label months with number
Dict_months = Dict("January" => 1,"February" => 2, "March" => 3, "April" => 4, "May" => 5, "June" => 6,
"July" => 7, "August" => 8,"September"=>9,"October"=>10,"November"=>11,"December"=>12)
#empty vector to put in month numbers
month_num = zeros(Int, size(df_not_canceled, 1))
for (index, h) in enumerate(df_not_canceled.arrival_date_month)
    month_num[index] = Dict_months[h]
end
#combine vectors to new dataframe
df_months_labeled = DataFrame(arrival_date_month = months, number_months = month_num)

function month(month_list::Array)
    Dict_months = Dict("January" => 1,"February" => 2, "March" => 3, "April" => 4, "May" => 5, "June" => 6, 
    "July" => 7, "August" => 8,"September"=>9,"October"=>10,"November"=>11,"December"=>12)
    month_num = zeros(Int, length(month_list))
    for (index, h) in enumerate(month_list)
        month_num[index] = Dict_months[h]
    end
end


#arrival week of the year
#binary encoding of 53 categories (53 weekss of the year)
weeks = df_not_canceled.arrival_date_week_number
#week numbers as binary
week_binary=string.(weeks, base=2, pad=6)
#temporary dataframe with only binaries
df_temp = DataFrame()
for i in 1:6
    a = [parse(Int, j[i]) for j in week_binary]
    df_temp[:, "d$i"] = a
end
#final dataframe with week number and binary
df_weeks = DataFrame(arrival_week_number = df_not_canceled.arrival_date_week_number, bin_week_number_1 = df_temp.d1, bin_week_number_2 = df_temp.d2, bin_week_number_3 = df_temp.d3, bin_week_number_4 = df_temp.d4, bin_week_number_5 = df_temp.d5, bin_week_number_6 = df_temp.d6)

function binary(list::Array)
    categories = skipmissing(unique(list))
    Dict_categories = Dict(enumerate(categories))

    p = length(categories)
    a = length(Base.bin(UInt(p), 1, false))
    bin = string.(1:p, base=2, pad=a)
    df_temporary = DataFrame()
    for i in 1:a
        b = [parse(Int, j[i]) for j in bin]
        df_temporary[:, "d$i"] = b
    end

    namesvec = []
    for i in 1:p
        push!(namesvec, Dict_categories[i])
    end
    df_final = DataFrame(categories = namesvec, bin_1 = df_temp.d1, bin_2 = df_temp.d2, bin_3 = df_temp.d2, bin_4 = df_temp.d4, bin_5 = df_temp.d5)
    return df_final
end

#US government dataframe
using DataFrames
using CSV
f_US = "USgovernment.csv"
df_US = CSV.read(f_US, DataFrame)
#choose colums that might be useful
df1 = DataFrame(project_id=df_US[!,6], lifecycle_cost=df_US[!,14], cost_variance=df_US[!,18], planned_cost=df_US[!,19])

#replace missing values with mean of that feature
using Statistics
mean_lc = mean(skipmissing(df2.lifecycle_cost))
mean_cv = mean(skipmissing(df2.cost_variance))
mean_pc = mean(skipmissing(df2.planned_cost))

#replaced_lc = [ismissing(i) ? mean_lc : i for i in df2.lifecycle_cost]
replaced_lc = replace(df2.lifecycle_cost, missing => mean_lc)
replaced_cv = replace(df2.cost_variance, missing => mean_ca)
replaced_pc = replace(df2.planned_cost, missing => mean_pc)

df3 = DataFrame(project_id = df2.project_id, lifecycle_cost = replaced_lc, cost_variance = replaced_ca, planned_cost = replaced_pc)

#standardization of the data
#standarddeviation 
std_lc = std(df3.lifecycle_cost)
std_cv = std(df3.cost_variance)
std_pc = std(df3.planned_cost)
#create function for z-score normalization (zsn)
zsn(x, m, s) = (x-m)/s
zsn_lc = zsn.(df3.lifecycle_cost, mean_lc, std_lc)
zsn_ca = zsn.(df3.cost_variance, mean_cv, std_cv)
zsn_pc = zsn.(df3.planned_cost, mean_pc, std_pc)
zsn_pac = zsn.(df3.projected_actual_cost, mean_pac, std_pac)

#final dataframe with standardized values and project id
df_final = DataFrame(project_id = df2.project_id, lifecycle_cost_norm = zsn_lc, cost_variance = zsm_cv, planned_cost_norm = zsn_pc)

function standardization(list::Array)
    using Statistics
    mean = mean.(skipmissing(list))
    replaced = replace(list, missing => mean)
    stan_div = std(replaced)

    zsn(x, m, s) = (x-m)/s
    standard = zsn.(replaced, mean, stan_div)

    return standard 
end


#binary encoding of agency name
an = df_US[!,4]
an_unique = skipmissing(unique(an))
#dictionary with enumerated agency names
Dict_an = Dict(enumerate(an_unique))

#dataframe with binary digits as colums
an_bin = string.(1:26, base=2, pad=5)
df_temp = DataFrame()
for i in 1:5
    a = [parse(Int, j[i]) for j in an_bin]
    df_temp[:, "d$i"] = a
end
df_temp
#vector with names in order 1 through 27 
namesvec = []
for i in 1:26
    push!(namesvec, Dict_an[i])
end

#dataframe with agency names and corresponding binary encoding
df_final_an = DataFrame(agency_name = namesvec, bin_1 = df_temp.d1, bin_2 = df_temp.d2, bin_3 = df_temp.d2, bin_4 = df_temp.d4, bin_5 = df_temp.d5)
