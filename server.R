# USS pension model in a web app
# Copyright (C) 2018 Gibran Hemani

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.



library(USSpensions)
library(tidyverse)
library(plotly)

server <- function(input, output)
{

	# 2018 model
	benefits <- reactive({
		pension_calculation(
			income=income_projection(input$input_income18, input$input_payinc18 / 100, years=years_left(input$input_dob18), upper_limit=1000000), 
			annuity=annuity_rates(sex=input$input_sex18, type=input$input_spouse18, years=years_left(input$input_dob18), le_increase=input$input_lei18 / 100),
			employee_cont=input$input_employeecont18 / 100, 
			employer_cont=input$input_employercont18 / 100, 
			prudence = as.numeric(input$input_invprudence18), 
			fund = input$input_invscheme18
		) %>% pension_summary(input$input_dob18)	  
	})

	output$retirement_year18 <- renderValueBox({
		valueBox(year(retirement_date(input$input_dob)), "Year of retirement based on date of birth", icon=icon("blind"))
	})

	output$retirement_year <- renderValueBox({
		valueBox(year(retirement_date(input$input_dob)), "Year of retirement based on date of birth", icon=icon("blind"))
	})

	output$dc_income <- renderValueBox({
		val <- benefits()$dc_pension
		valueBox(paste0("£", format(round(val), big.mark=",")), 
			"DC annual income (proposed)", icon=icon("list"), color="red")
	})

	output$db_income_perc <- renderValueBox({
		val <- (benefits()$dc_pension - benefits()$db_pension) / benefits()$db_pension * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Proposed change (comparing DC to DB)", icon=icon("cogs"), color="red")
	})

	output$db_income_diff <- renderValueBox({
		val <- benefits()$dc_pension - benefits()$db_pension
		valueBox(paste0("£", format(round(val), big.mark=",")), 
			"Proposed change (comparing DC to DB)", icon=icon("cogs"), color="red")
	})

	output$tps_income_perc <- renderValueBox({
		val <- (benefits()$db_pension - benefits()$tps_pension) / benefits()$tps_pension * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Comparison with TPS (DB vs TPS)", icon=icon("cogs"), color="yellow")
	})

	output$tps_income_diff <- renderValueBox({
		val <- benefits()$db_pension - benefits()$tps_pension
		valueBox(paste0("£", format(round(val), big.mark=",")), "Comparison with TPS (DB vs TPS)", icon=icon("cogs"), color="yellow")
	})

	output$dc_pot <- renderValueBox({
		val <- benefits()$dc_pot
		valueBox(paste0("£", format(round(val), big.mark=",")), "DC total pension value (proposed)", icon=icon("list"), color="red")
	})

	output$db_pot_perc <- renderValueBox({
		val <- (benefits()$dc_pot - benefits()$db_pot) / benefits()$db_pot * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Proposed change (comparing DC to DB)", icon=icon("cogs"), color="red")
	})

	output$db_pot_diff <- renderValueBox({
		val <- benefits()$dc_pot - benefits()$db_pot
		valueBox(paste0("£", format(round(val), big.mark=",")), 
			"Proposed change (comparing DC to DB)", icon=icon("cogs"), color="red")
	})

	output$tps_pot_perc <- renderValueBox({
		val <- (benefits()$db_pot - benefits()$tps_pot) / benefits()$tps_pot * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), "Comparison with TPS (DB vs TPS)", icon=icon("cogs"), color="yellow")
	})

	output$tps_pot_diff <- renderValueBox({
		val <- benefits()$db_pot - benefits()$tps_pot
		valueBox(paste0("£", format(round(val), big.mark=",")), "Comparison with TPS (DB vs TPS)", icon=icon("cogs"), color="yellow")

	})


	output$db_pot <- renderValueBox({
		val <- benefits()$db_pot
		valueBox(paste0("£", format(round(val), big.mark=",")), "DB total pension value (current)", icon=icon("list"), color="purple")
	})

	output$db_income <- renderValueBox({
		val <- benefits()$db_pension
		valueBox(paste0("£", format(round(val), big.mark=",")), "DB annual income (current)", icon=icon("list"), color="purple")
	}) 

	output$tps_pot <- renderValueBox({
		val <- benefits()$tps_pot
		valueBox(paste0("£", format(round(val), big.mark=",")), "Teachers Pension Scheme total pension value", icon=icon("list"), color="yellow")
	})

	output$tps_income <- renderValueBox({
		val <- benefits()$tps_pension
		valueBox(paste0("£", format(round(val), big.mark=",")), "Teachers Pension Scheme annual income", icon=icon("list"), color="yellow")
	})


	##########


	output$dc_income2 <- renderValueBox({
		val <- benefits()$db_pension2
		valueBox(paste0("£", format(round(val), big.mark=",")), 
			"DC annual income (proposed)", icon=icon("list"), color="red")
	})

	output$db_income_perc2 <- renderValueBox({
		val <- (benefits()$db_pension2 - benefits()$db_pension) / benefits()$db_pension * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Proposed change (comparing DC to DB)", icon=icon("cogs"), color="red")
	})

	output$db_income_diff2 <- renderValueBox({
		val <- benefits()$db_pension2 - benefits()$db_pension
		valueBox(paste0("£", format(round(val), big.mark=",")), 
			"Proposed change (comparing DC to DB)", icon=icon("cogs"), color="red")
	})


	output$dc_pot2 <- renderValueBox({
		val <- benefits()$db_pot2
		valueBox(paste0("£", format(round(val), big.mark=",")), "DC total pension value (proposed)", icon=icon("list"), color="red")
	})

	output$db_pot_perc2 <- renderValueBox({
		val <- (benefits()$db_pot2 - benefits()$db_pot) / benefits()$db_pot * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Proposed change (comparing DC to DB)", icon=icon("cogs"), color="red")
	})

	output$db_pot_diff2 <- renderValueBox({
		val <- benefits()$db_pot2 - benefits()$db_pot
		valueBox(paste0("£", format(round(val), big.mark=",")), 
			"Proposed change (comparing DC to DB)", icon=icon("cogs"), color="red")
	})


	output$dc_salary_percent <- renderValueBox({
	  val<-benefits()$dc_salary_percent
	  
	  valueBox(paste0(format(round(val*100,digits=1), big.mark=","), "%"), 
	           "Average % of income needed to invest per year to match DB", icon=icon("cogs"), color="red")
	})
	

	output$dc_salary_cut_now <- renderValueBox({
	  val<-benefits()$dc_salary_cut_now
	  
	  valueBox(paste0("£-", format(round(val), big.mark=",")), 
	           "Loss in current annual income to match difference", icon=icon("cogs"), color="red")
	})

	output$dc_salary_cut_final <- renderValueBox({
	  val<-benefits()$dc_salary_cut_final
	  
	  valueBox(paste0("£-", format(round(val), big.mark=",")), 
	           "Loss in projected final annual income to match difference", icon=icon("cogs"), color="red")
	})
	
	
	output$dc_salary_percent2 <- renderValueBox({
	  val <-benefits()$dc_salary_percent2
	  valueBox(paste0(format(round(val*100,digits=1), big.mark=","), "%"), 
	           "Average % of income needed to invest per year to match DB", icon=icon("cogs"), color="red")
	})
	
	output$dc_salary_cut_now2 <- renderValueBox({
	  val<-benefits()$dc_salary_cut_now2
	  
	  valueBox(paste0("£-", format(round(val), big.mark=",")), 
	           "Loss in current annual income to match difference", icon=icon("cogs"), color="red")
	})
	
	output$dc_salary_cut_final2 <- renderValueBox({
	  val<-benefits()$dc_salary_cut_final2
	  
	  valueBox(paste0("£-", format(round(val), big.mark=",")), 
	           "Loss in projected final income to match difference", icon=icon("cogs"), color="red")
	})
	
	
	output$tps_salary_percent <- renderValueBox({
	  
	  val <-benefits()$tps_salary_percent
	  
	  valueBox(paste0(format(round(val*100,digits=1), big.mark=","), "%"), 
	           "Average % of income to invest per year for DB to match TPS", icon=icon("cogs"), color="yellow")
	})
	
	
	output$tps_salary_cut_now <- renderValueBox({
	  val<-benefits()$tps_salary_cut_now
	  
	  valueBox(paste0("£-", format(round(val), big.mark=",")), 
	           "Loss in current annual income to match difference", icon=icon("cogs"), color="yellow")
	})
	
	output$tps_salary_cut_final <- renderValueBox({
	  val<-benefits()$tps_salary_cut_final
	  
	  valueBox(paste0("£-", format(round(val), big.mark=",")), 
	           "Loss in final annual income to match difference", icon=icon("cogs"), color="yellow")
	})


	# 2020 model
	benefits_2020 <- reactive({
		pension_calculation_2020(
			income=income_projection(
				input$input_income, 
				input$input_payinc / 100, 
				years=years_left(input$input_dob), 
				upper_limit=1000000
				), 
			annuity=annuity_rates(
				sex=input$input_sex, 
				type=input$input_spouse, 
				years=years_left(input$input_dob), 
				le_increase=input$input_lei / 100),
			scenario="Scenario 3a",
			incr = input$input_incr
		)
	})

	benefits_2020_summary <- reactive({
		benefits_2020() %>% pension_calculation_2020_summary()
	})

	output$plot_total_pot <- renderPlotly({
		p <- benefits_2020() %>%
		plot_pension() +
			scale_y_continuous(labels=function(x) paste0("£", x/1000)) +
			labs(y="Total pension value (x1000)")
		ggplotly(p)
	})
	
	output$current_income <- renderValueBox({
		val <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pension}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Projected annual income", icon=icon("list"), color="purple")
	})

	output$current_pot <- renderValueBox({
		val <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pot}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Projected total pension value", icon=icon("list"), color="purple")
	})

	output$scenario1_income <- renderValueBox({
		val <- benefits_2020_summary() %>%
			filter(scenario == "scenario_1") %>%
			{.$total_pension}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Projected annual income", icon=icon("list"), color="red")
	})

	output$scenario1_pot <- renderValueBox({
		val <- benefits_2020_summary() %>%
			filter(scenario == "scenario_1") %>%
			{.$total_pot}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Projected total pension value", icon=icon("list"), color="red")
	})

	output$scenario1_perc <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_1") %>%
			{.$total_pension}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pension}
		val <- (val1-val2)/val2 * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario1_pot_perc <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_1") %>%
			{.$total_pot}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pot}
		val <- (val1-val2)/val2 * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario1_pot_diff <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_1") %>%
			{.$total_pot}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pot}
		val <- val1-val2
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario2a_income <- renderValueBox({
		val <- benefits_2020_summary() %>%
			filter(scenario == "scenario_2a") %>%
			{.$total_pension}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Projected annual income", icon=icon("list"), color="red")
	})

	output$scenario2a_pot <- renderValueBox({
		val <- benefits_2020_summary() %>%
			filter(scenario == "scenario_2a") %>%
			{.$total_pot}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Projected total pension value", icon=icon("list"), color="red")
	})

	output$scenario2a_perc <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_2a") %>%
			{.$total_pension}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pension}
		val <- (val1-val2)/val2 * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario2a_pot_perc <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_2a") %>%
			{.$total_pot}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pot}
		val <- (val1-val2)/val2 * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario2a_pot_diff <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_2a") %>%
			{.$total_pot}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pot}
		val <- val1-val2
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario2b_income <- renderValueBox({
		val <- benefits_2020_summary() %>%
			filter(scenario == "scenario_2b") %>%
			{.$total_pension}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Projected annual income", icon=icon("list"), color="red")
	})

	output$scenario2b_pot <- renderValueBox({
		val <- benefits_2020_summary() %>%
			filter(scenario == "scenario_2b") %>%
			{.$total_pot}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Projected total pension value", icon=icon("list"), color="red")
	})

	output$scenario2b_perc <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_2b") %>%
			{.$total_pension}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pension}
		val <- (val1-val2)/val2 * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario2b_pot_perc <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_2b") %>%
			{.$total_pot}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pot}
		val <- (val1-val2)/val2 * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario2b_pot_diff <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_2b") %>%
			{.$total_pot}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pot}
		val <- val1-val2
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario3a_income <- renderValueBox({
		val <- benefits_2020_summary() %>%
			filter(scenario == "scenario_3a") %>%
			{.$total_pension}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Projected annual income", icon=icon("list"), color="red")
	})

	output$scenario3a_pot <- renderValueBox({
		val <- benefits_2020_summary() %>%
			filter(scenario == "scenario_3a") %>%
			{.$total_pot}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Projected total pension value", icon=icon("list"), color="red")
	})

	output$scenario3a_perc <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_3a") %>%
			{.$total_pension}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pension}
		val <- (val1-val2)/val2 * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario3a_pot_perc <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_3a") %>%
			{.$total_pot}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pot}
		val <- (val1-val2)/val2 * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario3a_pot_diff <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_3a") %>%
			{.$total_pot}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pot}
		val <- val1-val2
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario3b_income <- renderValueBox({
		val <- benefits_2020_summary() %>%
			filter(scenario == "scenario_3b") %>%
			{.$total_pension}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Projected annual income", icon=icon("list"), color="red")
	})

	output$scenario3b_pot <- renderValueBox({
		val <- benefits_2020_summary() %>%
			filter(scenario == "scenario_3b") %>%
			{.$total_pot}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Projected total pension value", icon=icon("list"), color="red")
	})

	output$scenario3b_perc <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_3b") %>%
			{.$total_pension}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pension}
		val <- (val1-val2)/val2 * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario3b_pot_perc <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_3b") %>%
			{.$total_pot}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pot}
		val <- (val1-val2)/val2 * 100
		valueBox(paste0(format(round(val), big.mark=","), "%"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	output$scenario3b_pot_diff <- renderValueBox({
		val1 <- benefits_2020_summary() %>%
			filter(scenario == "scenario_3b") %>%
			{.$total_pot}
		val2 <- benefits_2020_summary() %>%
			filter(scenario == "current") %>%
			{.$total_pot}
		val <- val1-val2
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Compared to current scheme", icon=icon("cogs"), color="red")
	})

	# contributions
	output$contributions_employee <- renderValueBox({
		val <- benefits_2020() %>%
			{sum(.$current$income * 0.096)}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Total employee contribution", icon=icon("cogs"), color="yellow")
	})

	output$contributions_employer <- renderValueBox({
		val <- benefits_2020() %>%
			{sum(.$current$income * 0.211)}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Total employer contribution", icon=icon("cogs"), color="yellow")
	})

	output$contributions_total <- renderValueBox({
		val <- benefits_2020() %>%
			{sum(.$current$income * (0.096+0.211))}
		valueBox(tags$p(paste0("£", format(round(val), big.mark=",")), style="font-size:75%;"), 
			"Employee + employer contributions", icon=icon("cogs"), color="yellow")
	})

}

