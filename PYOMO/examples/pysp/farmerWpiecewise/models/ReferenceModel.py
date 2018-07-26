#  ___________________________________________________________________________
#
#  Pyomo: Python Optimization Modeling Objects
#  Copyright 2017 National Technology and Engineering Solutions of Sandia, LLC
#  Under the terms of Contract DE-NA0003525 with National Technology and 
#  Engineering Solutions of Sandia, LLC, the U.S. Government retains certain 
#  rights in this software.
#  This software is distributed under the 3-clause BSD License.
#  ___________________________________________________________________________

#
# Imports
#

from pyomo.core import *

#
# Model
#

model = AbstractModel()

#
# Parameters
#

model.CROPS = Set()

model.TOTAL_ACREAGE = Param(within=PositiveReals)

model.CattleFeedRequirement = Param(model.CROPS, within=NonNegativeReals)

model.PurchasePrice = Param(model.CROPS, within=PositiveReals)

model.PlantingCostPerAcre = Param(model.CROPS, within=PositiveReals)

model.Yield = Param(model.CROPS, within=NonNegativeReals)

# the maximum possible yield for this scenario.
def max_yield_rule(m):
    result = 0
    acreage = value(m.TOTAL_ACREAGE)
    for c in m.CROPS:
       crop_yield = value(m.Yield[c])
       if crop_yield * acreage > result:
           result = crop_yield * acreage
    return result

model.MaxYield = Param(within=NonNegativeReals, initialize=max_yield_rule)

# number of pieces in the linear approximation of the profit curves.
model.NumProfitCurvePieces = Param(model.CROPS, default=2)

# the quadratic coefficients for the profit curve, per-crop.
model.SalePriceA0 = Param(model.CROPS, within=NonNegativeReals)
model.SalePriceA1 = Param(model.CROPS, within=NonNegativeReals)
model.SalePriceA2 = Param(model.CROPS, within=NonNegativeReals)

#
# Variables
#

model.DevotedAcreage = Var(model.CROPS, bounds=(0.0, model.TOTAL_ACREAGE))

model.QuantityPurchased = Var(model.CROPS, bounds=(0.0, None))

model.QuantitySold = Var(model.CROPS, bounds=(0.0, model.MaxYield))

# per-crop profit, based on the piecewise cost curves.
model.Profit = Var(model.CROPS, within=NonNegativeReals)

model.FirstStageCost = Var()
model.SecondStageCost = Var()

#
# Piecewise constructs
#

model.ProfitCurvePoints = {}

def create_profit_curve_points_rule(m):
    for c in m.CROPS:
        m.ProfitCurvePoints[c] = [0, value(m.MaxYield)/2, value(m.MaxYield)]

model.CreateProfitCurvePoints = BuildAction(rule=create_profit_curve_points_rule)

# a function for use in piecewise linearization of the profit function.
def profit_function(m, c, x):
    return value(m.SalePriceA0[c]) + value(m.SalePriceA1[c])*x + value(m.SalePriceA2[c])*x*x

# compute the per-crop profit - the "UB" is used because
# this is profit, which is a negative term in the
# (cost-oriented) objective.
model.ComputeProfits = Piecewise(model.CROPS,
                                 model.Profit,
                                 model.QuantitySold,
                                 pw_pts=model.ProfitCurvePoints,
                                 f_rule=profit_function,
                                 pw_constr_type='UB')

#
# Constraints
#

def ConstrainTotalAcreage_rule(model):
    return summation(model.DevotedAcreage) <= model.TOTAL_ACREAGE

model.ConstrainTotalAcreage = Constraint(rule=ConstrainTotalAcreage_rule)

def EnforceCattleFeedRequirement_rule(model, i):
    return model.CattleFeedRequirement[i] <= (model.Yield[i] * model.DevotedAcreage[i]) + model.QuantityPurchased[i] - model.QuantitySold[i]

model.EnforceCattleFeedRequirement = Constraint(model.CROPS, rule=EnforceCattleFeedRequirement_rule)

def LimitAmountSold_rule(model, i):
    return model.QuantitySold[i] - (model.Yield[i] * model.DevotedAcreage[i]) <= 0.0

model.LimitAmountSold = Constraint(model.CROPS, rule=LimitAmountSold_rule)

#
# Stage-specific cost computations
#

def ComputeFirstStageCost_rule(model):
    return model.FirstStageCost - summation(model.PlantingCostPerAcre, model.DevotedAcreage) == 0.0

model.ComputeFirstStageCost = Constraint(rule=ComputeFirstStageCost_rule)

def ComputeSecondStageCost_rule(model):
    return model.SecondStageCost - (summation(model.PurchasePrice, model.QuantityPurchased) - summation(model.Profit)) == 0.0

model.ComputeSecondStageCost = Constraint(rule=ComputeSecondStageCost_rule)

#
# PySP Auto-generated Objective
#
# minimize: sum of StageCosts
#
# A active scenario objective equivalent to that generated by PySP is
# included here for informational purposes.
def total_cost_rule(model):
    return model.FirstStageCost + model.SecondStageCost
model.Total_Cost_Objective = Objective(rule=total_cost_rule, sense=minimize)

