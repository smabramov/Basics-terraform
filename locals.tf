locals {
  platform  = "${ var.name }-${ var.env }-${ var.project }-${ var.role[0] }"
  platform2 = "${ var.name }-${ var.env }-${ var.project }-${ var.role[1] }"
}