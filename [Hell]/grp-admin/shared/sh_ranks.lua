GRP.Admin:AddRank("owner", {
    inherits = "dev",
    issuperadmin = true,
    allowafk = true,
    grant = 101
})

GRP.Admin:AddRank("dev", {
    inherits = "superadmin",
    issuperadmin = true,
    allowafk = true,
    grant = 100
})

GRP.Admin:AddRank("superadmin", {
    inherits = "admin",
    issuperadmin = true,
    allowafk = true,
    grant = 101
})

GRP.Admin:AddRank("admin", {
    inherits = "moderator",
    allowafk = true,
    isadmin = true,
    grant = 98
})

GRP.Admin:AddRank("moderator", {
    inherits = "trusted",
    isadmin = true,
    grant = 97
})

GRP.Admin:AddRank("trusted", {
    inherits = "user",
    isadmin = true,
    grant = 96
})

GRP.Admin:AddRank("user", {
    inherits = "",
    grant = 1
})