#ex.1
v1 = fill(0, 10)
v1[2] = 1


#ex.2
m2 = reshape(1:6, 3, 2)


#ex.3
v3 = [1,4,2,3,6,7]
odd = [i for i in v2 if i%2 != 0]


#ex.4
m4_1 = rand(5,3)
m4_2 = rand(3,2)

m4_3 = m4_1*m4_2


#ex.5
f5(x) = reverse()
f5("Laura")

#ex.6
function Palindrome(word)
    if word == reverse(word)
        print("it's a palindrome")
    end
end
   
Palindrome("anna")


#ex.7
function DNA(x)
    RNA = []
    for n in x
        if n == 'T'
            push!(RNA, 'U')
        else
            push!(RNA, n)
        end
    end
    return join(RNA)
end

DNA("TAGCGGCATTAG")


#ex.8
function isogram(word)
    db = []
    for char in word
        if char in db
            return "not an isogram"
        else
            push!(db, char)
        end
    end
end

isogram("hello")


#ex.9
function duplicates(x::String)
    l1 = []
    for char in x
        push!(l1, char^2)
    end
    return (length(x), join(l1)::String)
end

function duplicates(x::Array)
    a1 = eltype(x)[]
    for num in x
        push!(a1, num, num)
    end
    return(length(x), a1)
end

duplicates([1, 2, 3, 4])
duplicates("hello")


#ex.10
function nestedsum(a::Array)
    tot = 0
    for a1::Array in a
        for a2::Integer in a1
            tot = tot + a2      
        end
    end
    return tot
end

nestedsum([[1,2],[3],[4,5,6]])


#ex.11
function is_duplicate(x::Array)
    if length(Set(x)) != length(x)
        return true
    else
        return false
    end
end

function duplicates_array(x::Array)
    if is_duplicate(x) == true
        db = []
        all = []
        for num in x
            if num in all
                push!(db, num)
            else
                push!(all, num)
            end    
        end
    end
    pos = []
    for i in db
        push!(pos, (i, findall(a -> a==i, x)))
    end
    return pos
end

duplicates_array([1, 2, 2, 3, 4])


#ex.12 
mutable struct Point
    x::Float64
    y::Float64
end

mutable struct Circle
    center::Point
    radius::Float64
end

function area(circle::Circle)
    area = 2*pi*circle.radius^2
    return area
end

mutable struct Square
    side::Float64
end

function area(square::Square)
    area = square.side^2
    return area
end

function overlap(circle1::Circle, circle2::Circle)
    dist = sqrt((circle1.center.x-circle2.center.x)^2+(circle1.center.y-circle2.center.y)^2)
    if circle1.radius + circle2.radius <= dist
        return "circles do not overlap"
    else 
        return "circles overlap"
    end
end


#ex.13
using RDatasets
df = dataset("datasets","anscombe")

#values of the first colum less than mean of the fifth colum
mean_5 = mean(df[!, 5])
subset = filter(:X1 => X1 -> X1 < mean_5, df)

#sort by first and fifth colum
sorted_1 = sort!(subset, :X1)
sorted_5 = sort!(subset, :Y1)

#write to file
using CSV
CSV.write("ex13.csv", subset)


#ex.14
df_file = CSV.read("ex13.csv", DataFrame)


#ex15
using RDatasets
df = dataset("car","Chile")
df_no_missing = dropmissing(df)

ed_p = []
for i in df_no_missing.Education
    if i == "P"
        push!(ed_p, 1)
    else 
        push!(ed_p, 0)
    end
end

ed_s = []
for i in df_no_missing.Education
    if i == "S"
        push!(ed_s, 1)
    else 
        push!(ed_s, 0)
    end
end

df_ohe = DataFrame(Region = df_no_missing.Region, Population = df_no_missing.Population, Sex = df_no_missing.Sex, Age = df_no_missing.Age, Education_P = ed_p, Education_S = ed_s, Income = df_no_missing.Income, StatusQuo = df_no_missing.StatusQuo, Vote = df_no_missing.Vote)


#ex16
using RDatasets
chile = dataset("car","Chile")
sex = chile[!, :Sex] 

#convert sex to integer to scatter by color according to sex
function unique_array(array) 
    un_ar = unique(array) 
    dic = Dict(v=> k for (k,v) in enumerate(un_ar)) 
    return dic
end

#takes column to convert it into an array of integers and also makes dictionary
function integer_data(column, sze::Int, dic) 
    int_ar = Int[]
    dic = dic
    for h in column
        push!(int_ar, dic[h])
    end
    b=Base.bin.(UInt.(int_ar), sze, false)
    return(int_ar, b)
end

un_a = unique_array(sex)
int_ar_sex, b = integer_data(sex, 1, un_a) 
[parse(Int, x) for x in b]

#scatterplots
using Plots
x = chile[!, :Education]
y1 = chile[!, :Age]
y2 = chile[!, :Income]

plot(x, y1, color=int_ar_sex,  seriestype = :scatter, title = "Education level at different ages", xlab = "Education", ylab = "Age")
plot(x, y2, color=int_ar_sex, seriestype = :scatter, title = "Income / Education", xlab  ="Educaction", ylab = "Income")
