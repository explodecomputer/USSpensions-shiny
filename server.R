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

server <- function(input, output)
{
	benefits <- reactive({
		pension_calculation(
			income=income_projection(input$input_income, input$input_payinc / 100, years=68, upper_limit=1000000), 
			annuity=annuity_rates(sex=input$input_sex, type=input$input_spouse, years=68, le_increase=input$input_lei / 100),
			employee_cont=input$input_employeecont / 100, 
			employer_cont=input$input_employercont / 100, 
			prudence = as.numeric(input$input_invprudence), 
			fund = input$input_invscheme
		) %>% pension_summary(input$input_dob)
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

}