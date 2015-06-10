function reducedCosts(A::Array{Float64, 2},
                      Binv::Array{Float64, 2},
                      c::Array{Float64, 1},
                      bind::Array{Int, 1},
                      nbind::Array{Int, 1})

    println("Reduced Costs:")

    # Calculate the reduced costs in a vectorized way
    # println(Binv)
    # println(c[bind])
    p_T = vec(c[bind]'*Binv) # p is a transposed vector here
    # println(p_T)

    # Compute reduced costs until find the first negative one
    for i in nbind
      # Compute the reduced cost
      redc = c[i] - p_T⋅A[:, i]
      # Print the computed reduced cost
      println(i, " ", redc)
      # Return if negative
      all(redc .< 0) && return redc, i
    end

    # If no negative costs are found, return ind = 0 and redc = 0
    return 0, 0
end

function theta(xB::Array{Float64,1},
               dB::Array{Float64,1})

    # Computes the largest step we can do
    # without leaving the polyhedra
    Θ, imin = Inf, 0
    for i in 1:length(xB)
         @inbounds if dB[i] < 0
            aux = - xB[i] / dB[i]
            if aux < Θ
                Θ = aux
                imin = i
            end
        end
    end

    return Θ, imin
end

function updateBinv!(Binv, u, out)
    for i in eachindex(u)
        if i != out
            Binv[i, :] += (-u[i]/u[out]) * Binv[out, :]
        end
    end
    Binv[out,:] /= u[out]
end

function print_vec(indexes, v::Array{Float64, 1})
    # Print a vector and correspondent indexes
    for i=1:length(v)
        @inbounds println(indexes[i], " ", v[i])
    end
end

function print_bind(bind::Array{Int, 1}, x::Array{Float64, 1})
    # Print "basic elements" of a vector
    for i = 1:length(bind)
        @inbounds println(bind[i], " ", x[bind[i]])
    end
end
