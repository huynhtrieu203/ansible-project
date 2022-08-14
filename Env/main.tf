module "network" {
  source     = "../modules/network"
}

module "instance" {
  depends_on = [module.network, module.database]
  source     = "../modules/instance"
  vpc_id     = module.network.vpc_id
  subnet_id  = module.network.subnets
}

module "database" {
  depends_on = [module.network]
  source     = "../modules/database"
}

