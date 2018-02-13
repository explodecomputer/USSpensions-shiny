library(USSpensions)

server <- function(input, output)
{
	benefits <- reactive({
		pension_calculation(
			income=income_projection(input$input_income, input$input_payinc / 100, years=68, upper_limit=input$input_maxpay), 
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
		valueBox(paste0("£", round(benefits()$dc_pension)), "DC annual income (proposed)", icon=icon("list"), color="purple")
	})

	output$db_income_perc <- renderValueBox({
		valueBox(
			paste0(round(
				(benefits()$dc_pension - benefits()$db_pension) / benefits()$db_pension * 100), "%"), 
			"Change compared to DB (current)", icon=icon("cogs"), color="red")
	})

	output$tps_income_perc <- renderValueBox({
		valueBox(paste0(round(
				(benefits()$dc_pension - benefits()$tps_pension) / benefits()$tps_pension * 100), "%"), "Comparison with Teachers Pension Scheme", icon=icon("cogs"), color="yellow")

	})


	output$dc_pot <- renderValueBox({
		valueBox(paste0("£", round(benefits()$dc_pot)), "DC total pension value (proposed)", icon=icon("list"), color="purple")
	})

	output$db_pot_perc <- renderValueBox({
		valueBox(
			paste0(round(
				(benefits()$dc_pot - benefits()$db_pot) / benefits()$db_pot * 100), "%"), 
			"Change compared to DB (current)", icon=icon("cogs"), color="red")
	})

	output$tps_pot_perc <- renderValueBox({
		valueBox(paste0(round(
				(benefits()$dc_pot - benefits()$tps_pot) / benefits()$tps_pot * 100), "%"), "Comparison with Teachers Pension Scheme", icon=icon("cogs"), color="yellow")

	})

	output$db_pot <- renderValueBox({
		valueBox(paste0("£", round(benefits()$db_pot)), "DB total pension value (current)", icon=icon("list"), color="red")
	})

	output$db_income <- renderValueBox({
		valueBox(paste0("£", round(benefits()$db_pension)), "DB annual income (current)", icon=icon("list"), color="red")
	}) 

	output$tps_pot <- renderValueBox({
		valueBox(paste0("£", round(benefits()$tps_pot)), "TPS total pension value", icon=icon("list"), color="yellow")
	})

	output$tps_income <- renderValueBox({
		valueBox(paste0("£", round(benefits()$tps_pension)), "TPS annual income", icon=icon("list"), color="yellow")
	})

}