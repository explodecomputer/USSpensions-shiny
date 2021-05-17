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



library(shinydashboard)
library(plotly)
library(shinycssloaders)

inputs2020 <- function()
{
	column(width=3,
	fluidRow(
		box(width=12, title="2020 USS valuation",
			p("This is a simple web app that estimates the impacts of the various proposed changes to the USS pension scheme."),
			p("Version: ",
				strong(
					paste0(
						paste(scan("version.txt", what=character()), collapse=" "), " (", format(as.Date(file.info("version.txt")$mtime,), "Last update: %d %B %Y"), ")")))
		)
	),
	fluidRow(
		box(title="Your details", width=12,
			fluidRow(
				column(width=6,
					numericInput("input_income", "Income (£):", 35000, min=0, max=1000000)
				),
				column(width=6,
					dateInput("input_dob", "Date of birth:", value="1984-09-06")
				)
			),
			fluidRow(
				column(width=6, radioButtons("input_sex", "Sex:", c("Female"="women", "Male"="men"))),
				column(width=6, radioButtons("input_spouse", "Spouse:", c("No"="single", "Yes"="joint")))
			)
		)
	),
	fluidRow(
		box(title="Technical assumptions (see Details tab)", width=12,
			fluidRow(
				column(width=6,
					numericInput("input_payinc", "Annual % change in pay (after CPI)", 2, min=0, max=100)
				),
				column(width=6,
					numericInput("input_lei", "% Increase in life expectancy / year", 0.5, min=-100, max=100)
				),
				column(width=6,
				       radioButtons("input_incr", "Inflation assumptions:", 
				                    c("2.5% Cap, 1996-Present"="incr_sim_post96_2.5",
				                      "5% Cap, 1996-Present"="incr_sim_post96_5",
				                      "2.5% Cap, 1947-Present"="incr_sim_all_2.5",
				                      "5% Cap, 1947-Present"="incr_sim_all_5"
				                      ))
				)
			)
		)
	),
	fluidRow(
		valueBoxOutput("retirement_year", width=12)
	)
	)
}

inputs2018 <- function()
{
	column(width=3,
		fluidRow(
			box(width=12, title="2018 USS valuation",
				p("This is a simple web app that estimates the impacts of the various proposed changes to the USS pension scheme."),
				p("Version: ",
					strong(
						paste0(
							paste(scan("version.txt", what=character()), collapse=" "), " (", format(as.Date(file.info("version.txt")$mtime,), "Last update: %d %B %Y"), ")")))
			)
		),
		fluidRow(
			box(title="Your details", width=12,
				fluidRow(
					column(width=6,
						numericInput("input_income18", "Income (£):", 35000, min=0, max=1000000)
					),
					column(width=6,
						dateInput("input_dob18", "Date of birth:", value="1984-09-06")
					)
				),
				fluidRow(
					column(width=6, radioButtons("input_sex18", "Sex:", c("Female"="women", "Male"="men"))),
					column(width=6, radioButtons("input_spouse18", "Spouse:", c("No"="single", "Yes"="joint")))
				)
			)
		),
		fluidRow(
			box(title="Technical assumptions (see About page)", width=12,
				fluidRow(
					column(width=6,
						numericInput("input_payinc18", "Annual % change in pay (after CPI)", 2, min=0, max=100)
					),
					column(width=6,
						numericInput("input_lei18", "% Increase in life expectancy / year", 0.5, min=-100, max=100)
					),
				)
			)
		),
		fluidRow(box(title="Contributions to DC pension (see About page)", width=12,
			fluidRow(
				column(width=6,
					numericInput("input_employeecont18", "Employee contribution (%)", 7.65, min=0, max=100)
				),
				column(width=6,
					numericInput("input_employercont18", "Employer contribution (%)", 12, min=0, max=100)
				)
			)
		)),
		fluidRow(box(title="Investment assumptions", width=12,
			fluidRow(
				column(width=6,
					radioButtons("input_invscheme18", "Assumed investment scheme", c("USS", "Growth fund", "Moderate growth fund", "Cautious growth fund", "Cash fund"))
				),
				column(width=6,
					radioButtons("input_invprudence18", "Investment prudence", c(67, 50))
				)
			)
		)),
		fluidRow(
			valueBoxOutput("retirement_year18", width=12)
		)
	)
}

model_2018a <- function()
{
	fluidRow(
		column(width=3,
			fluidRow(box(title="Projections under the current scheme", width=12, collapsible = TRUE, collapsed = TRUE,
				p("This column shows the projected pension value under the current scheme"),
				p("The current scheme uses a defined benifits scheme (DB) up to an income threshold of £55,000, and applies a defined contributions (DC) scheme to income above this threshold."))
			)
		),
		column(width=3,
			fluidRow(box(title="The UUK's proposal (23/01/2018)", width=12, collapsible = TRUE, collapsed = TRUE,
				p("This column shows the projected pension value under the scheme initially proposed by UUK"),
				p("It eliminates the DB proportion (essentially setting it to 0), so the entire pension comes from the DC pension")
			))
		),
		column(width=3,
			fluidRow(box(title="The UCU+UUK compromise (12/03/2018)", width=12, collapsible = TRUE, collapsed = TRUE,
				p("Following strike action the UCU and UUK returned to negotiations"),
				p(tags$a("Main changes", href="https://www.ucu.org.uk/media/9300/Agreement-reached-between-UCU-and-UUK-under-the-auspices-of-ACAS/pdf/UCU_UUK_agreement_at_ACAS_12_March_Final.pdf"), " modelled here are that DB contribution threshold drops from £55k to £42k, and the accrual rate has dropped from 1/75 to 1/85. Other changes have not been modelled, most notably that CPI is capped up to 2.5%. If inflation raises substantially then this could have a dramatically negative impact on pension values.")
			))
		),
		column(width=3,
			fluidRow(box(title="Comparison to Teachers Pension Scheme", width=12, collapsible = TRUE, collapsed = TRUE,
				p("This column shows the projected pension value for employees at new universities that use the Teachers Pension Scheme. It is shown here for comparison.")
			))
		)
	)
}
model_2018b <- function()
{
	fluidRow(
		column(width=3,
			fluidRow(valueBoxOutput("db_income", width=12) %>% withSpinner())
		),
		column(width=3,
			fluidRow(valueBoxOutput("dc_income", width=12)),
			fluidRow(valueBoxOutput("db_income_diff", width=12)),
			fluidRow(valueBoxOutput("db_income_perc", width=12))
		),
		column(width=3,
			fluidRow(valueBoxOutput("dc_income2", width=12)),
			fluidRow(valueBoxOutput("db_income_diff2", width=12)),
			fluidRow(valueBoxOutput("db_income_perc2", width=12))
		),
		column(width=3,
			fluidRow(valueBoxOutput("tps_income", width=12)),
			fluidRow(valueBoxOutput("tps_income_diff", width=12)),
			fluidRow(valueBoxOutput("tps_income_perc", width=12))
		)				
	)
}
model_2018c <- function()
{
	fluidRow(
		column(width=3,
			fluidRow(valueBoxOutput("db_pot", width=12))
		),
		column(width=3,
			fluidRow(valueBoxOutput("dc_pot", width=12)),
			fluidRow(valueBoxOutput("db_pot_diff", width=12)),
			fluidRow(valueBoxOutput("db_pot_perc", width=12))
			
		),
		column(width=3,
			fluidRow(valueBoxOutput("dc_pot2", width=12)),
			fluidRow(valueBoxOutput("db_pot_diff2", width=12)),
			fluidRow(valueBoxOutput("db_pot_perc2", width=12))
		),
		column(width=3,
			fluidRow(valueBoxOutput("tps_pot", width=12)),
			fluidRow(valueBoxOutput("tps_pot_diff", width=12)),
			fluidRow(valueBoxOutput("tps_pot_perc", width=12))
		)
	)
}
model_2018d <- function()
{
	fluidRow(
	  column(width=3,
	         fluidRow(box(title="Effect on annual salary", width=12,color="blue"))
	   ),
	   column(width=3,
	          fluidRow(valueBoxOutput("dc_salary_percent", width=12)),
	          fluidRow(valueBoxOutput("dc_salary_cut_now", width=12)),
	          fluidRow(valueBoxOutput("dc_salary_cut_final", width=12))
	   ),
	   column(width=3,
	  
	          fluidRow(valueBoxOutput("dc_salary_percent2", width=12)),
	          fluidRow(valueBoxOutput("dc_salary_cut_now2", width=12)),
	          fluidRow(valueBoxOutput("dc_salary_cut_final2", width=12))
	   ),
	   column(width=3,
	  
	          fluidRow(valueBoxOutput("tps_salary_percent", width=12)),
	          fluidRow(valueBoxOutput("tps_salary_cut_now", width=12)),
	          fluidRow(valueBoxOutput("tps_salary_cut_final", width=12))
		)
	)
}

model_2018_details <- function()
{
	tabPanel("Details",
		p("This model was first created to understand the USS's 2018 valuation. It forecasts the benefits that you will accrue under three different schemes:"),
		p(tags$ul(
			tags$li("What you would get if the scheme remained unchanged (Defined benefits, DB)"),
			tags$li("What USS is proposing (Defined contribution, DC)"),
			tags$li("What the Teachers Pension Scheme provides (TPS) for comparison")
		)),
		p(strong("Note:"), "This is for future benefits only. The proposed changes will not impact benefits that have already been accrued, and this has not been modelled. This is an independent web app. It is not in any way affiliated with USS."),
			fluidRow(box(width=12,title="Assumptions",
				p("Most assumptions are taken from the",  tags$a("USS valuation document", href="https://www.sheffield.ac.uk/polopoly_fs/1.728969!/file/USSTechnicalprovisionsconsultationdocumentSept2017.pdf")),
				p("All figures are in real terms - i.e. after inflation."),
				p(tags$strong("The modeller only models the pensions we will accrue in future - pensions already earned will not be changed.")),
				p("Further details about the assumptions are provided on the tabs below."),
				p("The modeller assumes that you will buy an annuity at retirement with your DC pot and that the DB pension is bought using an annuity."),
				p("Salary changes take into account increments and cost of living awards.")
			)),

			fluidRow(box(width=12,title="Contributions",
				p("Under the current scheme 8% (employee) + 12% (employer) of income above £55,500 is contributed to the DC pension by default.  You may also have opted for additional 1% of salary to be contributed, which under current scheme is matched by a 1% employer contribution. This can be modelled by setting the contribution rates to 9%/13%. Note that the model for the proposed changes fixes the contributions based on the UUK proposal at 8%/13.25% employee/employer contribution. 0.35% of employee contrubutions are deducted for death/ill health cover.")
			)),

			fluidRow(box(width=12,title="Life expectancy",

				p("The model assumes that if life expectancy increases by 1% the cost of purchasing a given amount of pension income increases by 1%."),
				p("Originally the assumption on increase in life expectancy of 1.5% per year was taken from the ", tags$a("USS valuation document", href="https://www.sheffield.ac.uk/polopoly_fs/1.728969!/file/USSTechnicalprovisionsconsultationdocumentSept2017.pdf"), ", which it reports to have taken from CMI 2015. However this is much higher than the 0.5% value for males and 0.4% value for females projected by the ", tags$a("Office for National Statistics", href="https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/expectationoflifeprincipalprojectionunitedkingdom"), ". As of 24/2/2018 we have switched the default value to be 0.5%."),
				p("Update 23/03/2018: Important to note that ", tags$a(href="http://jech.bmj.com/content/early/2018/02/20/jech-2017-210401.info", "some projections for changes to life expectancy are levelling out"), ", and you may wish to set this field to 0% for comparison")
			)),

			fluidRow(box(width=12,title="Investment returns",
				p("The assumed returns are taken from the USS valuation documents. The model allows for five different investment returns:"),
				tags$ul(
					tags$li("USS - the return expected for the current USS portfolio. This is not an option for a DC pension and is provided for information only."),
					tags$li("Growth fund. The majority of this fund is invested in company shares"),
					tags$li("Moderate growth fund. This is invested in a mixture of shares and bonds."),
					tags$li("Cautious growth fund. This is mainly invested in high quality government and corporate bonds."),
					tags$li("Cash fund - this is invested in cash.")
				),
				p("The DC pensions typically sell company shares and buy high quality government debt and corporate bonds near retirement. This lowers investment returns near retirement. This model does not take this into account and means the estimates of the return to DC investments to be over estimates."),

				p("Each investment has two sets of estimated return:"),
				tags$ul(
					tags$li("The 50% 'best estimate'. The USS expects returns to be better than this 50% of the time."),
					tags$li("The second option is a more conservative 67% estimate. The USS expects returns to better than this 67% of the time.")
				)
			))	)
}

model_2020_uuk <- function()
{
  div(
    p("We present projections of your future pension income from Defined Benefit (where you accrue income each year) and Defined Contribution (where you have your own investment) and the total value of benefits, including lump sum, based on the assumptions used in the USS 2020 valuation."),
    p("Five scenarios were previously presented by the USS, and since then UUK has made two counter-proposals. We show the UUK proposals here. Click the '+' button to get a brief description for each. A comparison is provided against projections based on the current deal. More information in the Details tab."),
    p(tags$strong("NB. None of the proposals affect past benefits - pension values that have already accumulated are not going to be affected")),
    tags$hr(),
    h3("Contributions"),
    p("Currently employees make a pension contribution of 9.6% of their income and employers contribute 21.1%. Assuming these contribution rates remain fixed, projections for the total contributions are provided below."),
    model_2020d_uuk(),
    tags$hr(),
    h3("Total pension value projections"),
    p("Assuming the contribution rates above remain fixed over time, the following estimates are based on the fraction of the contributions that are allocated towards the DC component of the pension, and other assumptions such as UUK's proposed investment returns."),
    model_2020c_uuk(),
    tags$hr(),
    h3("Annual income projections"),
    model_2020b_uuk(),
    tags$hr()
  )
}


model_2020_uss <- function()
{
  div(
    p("We present projections of your future pension income from Defined Benefit (where you accrue income each year) and Defined Contribution (where you have your own investment) and the total value of benefits, including lump sum, based on the assumptions used in the USS 2020 valuation."),
    p("Below are the five scenarios initially presented by the USS as part of the 2020 valuation. Click the '+' button to get a brief description for each. A comparison is provided against projections based on the current deal. More information in the Details tab."),
    tags$hr(),
    h3("Contributions"),
    p("Currently employees make a pension contribution of 9.6% of their income and employers contribute 21.1%. Assuming these contribution rates remain fixed, projections for the total contributions are provided below."),
    model_2020d_uss(),
    tags$hr(),
    h3("Total pension value projections"),
    p("Assuming the contribution rates above remain fixed over time, the following estimates are based on the fraction of the contributions that are allocated towards the DC component of the pension, and other assumptions such as UUK's proposed investment returns."),
    model_2020c_uuk(),
    tags$hr(),
    h3("Annual income projections"),
    model_2020b_uuk(),
    tags$hr()
  )
}

model_2020c_uuk <- function()
{fluidRow(
  column(width=4,
         fluidRow(box(title="Current Scheme", width=12, collapsible = TRUE, collapsed = TRUE,
                      p("This column shows the projected pension value under the current scheme"),
                      p("The current scheme uses a defined benefits scheme (DB) up to an income threshold of £59,883, and applies a defined contributions (DC) scheme to income above this threshold."))
         ),
         fluidRow(valueBoxOutput("current_pot", width=12)),
  ),
  column(width=4,
         fluidRow(box(title="UUK Proposal 1", width=12, collapsible = TRUE, collapsed = TRUE,
                      p("This column shows the projected pension value under UUK proposal 1"),
                      p("This proposal applies DB pension contributions at 1/85th of salary until pot reaches £40,000, at which point it changes to a DC pension where employees contribute 9.6% and employers contribute 10.2%.")
         )),
         fluidRow(valueBoxOutput("uuk1_pot", width=12)),
         fluidRow(valueBoxOutput("uuk1_pot_perc", width=12)),
         fluidRow(valueBoxOutput("uuk1_pot_diff", width=12))
  ),
  column(width=4,
         fluidRow(box(title="UUK Proposal 2", width=12, collapsible = TRUE, collapsed = TRUE,
                      p("This column shows the projected pension value under UUK proposal 2"),
                      p("This proposal applies DB pension contributions at 1/75th of salary until pot reaches £30,000, at which point it changes to a DC pension where employees contribute 9.6% and employers contribute 10.2%.")
         )),
         fluidRow(valueBoxOutput("uuk2_pot", width=12)),
         fluidRow(valueBoxOutput("uuk2_pot_perc", width=12)),
         fluidRow(valueBoxOutput("uuk2_pot_diff", width=12))
  )			
)
}

model_2020b_uuk <- function()
{
  fluidRow(
    column(width=4,
           fluidRow(box(title="Current scheme", width=12, collapsible = TRUE, collapsed = TRUE,
                        p("This column shows the projected pension value under the current scheme"),
                        p("The current scheme uses a defined benefits scheme (DB) up to an income threshold of £59,883, and applies a defined contributions (DC) scheme to income above this threshold."))
           ),
           fluidRow(valueBoxOutput("current_income", width=12))
    ),
    column(width=4,
           fluidRow(box(title="UUK Proposal 1", width=12, collapsible = TRUE, collapsed = TRUE,
                        p("This column shows the projected pension value under UUK proposal 1"),
                        p("This proposal applies DB pension contributions at 1/85th of salary until pot reaches £40,000, at which point it changes to a DC pension where employees contribute 9.6% and employers contribute 10.2%.")
           )),
           fluidRow(valueBoxOutput("uuk1_income", width=12)),
           fluidRow(valueBoxOutput("uuk1_perc", width=12))
    ),
    column(width=4,
           fluidRow(box(title="UUK Proposal 2", width=12, collapsible = TRUE, collapsed = TRUE,
                        p("This column shows the projected pension value under UUK proposal 2"),
                        p("This proposal applies DB pension contributions at 1/75th of salary until pot reaches £30,000, at which point it changes to a DC pension where employees contribute 9.6% and employers contribute 10.2%.")
           )),
           fluidRow(valueBoxOutput("uuk2_income", width=12)),
           fluidRow(valueBoxOutput("uuk2_perc", width=12))
    )
  )
}


# model_2020 <- function()
# {
# 	div(
# 		p("We present projections of your future pension income from Defined Benefit (where you accrue income each year) and Defined Contribution (where you have your own investment) and the total value of benefits, including lump sum, based on the assumptions used in the USS 2020 valuation. Five scenarios were presented (1, 2a, 2b, 3a, 3b), click the '+' button to get a brief description for each. A comparison is provided against projections based on the current deal. More information in the Details tab."),
# 		tags$hr(),
# 		h3("Total pension value projections"),
# 		p("Assuming the contribution rates above remain fixed over time, the following estimates are based on the fraction of the contributions that are allocated towards the DC component of the pension, and other assumptions such as USS's projected investment returns."),
# 		model_2020c(),
# 		tags$hr(),
# 		h3("Annual income projections"),
# 		model_2020b(),
# 		tags$hr(),
# 		p("The graph below shows the growth of the value of your pension over time across the various scenarios, including the current deal. The projected value of your final pension is the value at the right-most end of the x-axis - i.e. at in the projected year of your retirement."),
# 		model_2020_plot()
# 	)
# }

# model_2020b <- function()
# {
# 	fluidRow(
# 		column(width=2,
# 			fluidRow(box(title="Current scheme", width=12, collapsible = TRUE, collapsed = TRUE,
# 				p("This column shows the projected pension value under the current scheme"),
# 				p("The current scheme uses a defined benifits scheme (DB) up to an income threshold of £59,883, and applies a defined contributions (DC) scheme to income above this threshold."))
# 			),
# 			fluidRow(valueBoxOutput("current_income", width=12)),
# 		),
# 		column(width=2,
# 			fluidRow(box(title="Proposed scenario 1", width=12, collapsible = TRUE, collapsed = TRUE,
# 				p("This column shows the projected pension value under 2020 valuation scenario 1"),
# 				p("It eliminates the DB proportion (essentially setting it to 0), so the entire pension comes from the DC pension with employee contributions of 9.6% and employer contributions of 1.8%")
# 			)),
# 			fluidRow(valueBoxOutput("scenario1_income", width=12)),
# 			fluidRow(valueBoxOutput("scenario1_perc", width=12))
# 		),
# 		column(width=2,
# 			fluidRow(box(title="Proposed scenario 2a", width=12, collapsible = TRUE, collapsed = TRUE,
# 				p("This column shows the projected pension value under 2020 valuation scenario 2a"),
# 				p("It applies DB pension with accrual rate of 1/170, and a DC pension after salary reaches £40,000 towards which employees contribute 12% and employees contribute 0%.")
# 			)),
# 			fluidRow(valueBoxOutput("scenario2a_income", width=12)),
# 			fluidRow(valueBoxOutput("scenario2a_perc", width=12))
# 		),
# 		column(width=2,
# 			fluidRow(box(title="Proposed scenario 2b", width=12, collapsible = TRUE, collapsed = TRUE,
# 				p("This column shows the projected pension value under 2020 valuation scenario 2b"),
# 				p("It applies DB pension with accrual rate of 1/165, and a DC pension after salary reaches £30,000 towards which employees contribute 12% and employees contribute 0%.")
# 			)),
# 			fluidRow(valueBoxOutput("scenario2b_income", width=12)),
# 			fluidRow(valueBoxOutput("scenario2b_perc", width=12))
# 		),
# 		column(width=2,
# 			fluidRow(box(title="Proposed scenario 3a", width=12, collapsible = TRUE, collapsed = TRUE,
# 				p("This column shows the projected pension value under 2020 valuation scenario 3a"),
# 				p("It applies DB pension with accrual rate of 1/115, and a DC pension after salary reaches £40,000 towards which employees contribute 16% and employees contribute 0%.")
# 			)),
# 			fluidRow(valueBoxOutput("scenario3a_income", width=12)),
# 			fluidRow(valueBoxOutput("scenario3a_perc", width=12))
# 		),
# 		column(width=2,
# 			fluidRow(box(title="Proposed scenario 3b", width=12, collapsible = TRUE, collapsed = TRUE,
# 				p("This column shows the projected pension value under 2020 valuation scenario 3b"),
# 				p("It applies DB pension with accrual rate of 1/110, and a DC pension after salary reaches £30,000 towards which employees contribute 16% and employees contribute 0%.")
# 			)),
# 			fluidRow(valueBoxOutput("scenario3b_income", width=12)),
# 			fluidRow(valueBoxOutput("scenario3b_perc", width=12))
# 		)				
# 	)
# }
# 
# model_2020c <- function()
# {
# 	fluidRow(
# 		# column(width=2,
# 		# 	fluidRow(box(title="Current scheme", width=12, collapsible = TRUE, collapsed = TRUE,
# 		# 		p("This column shows the projected pension value under the current scheme"),
# 		# 		p("The current scheme uses a defined benifits scheme (DB) up to an income threshold of £59,883, and applies a defined contributions (DC) scheme to income above this threshold."))
# 		# 	),
# 		# 	fluidRow(valueBoxOutput("current_pot", width=12)),
# 		# ),
# 		column(width=2,
# 			fluidRow(box(title="Proposed scenario 1", width=12, collapsible = TRUE, collapsed = TRUE,
# 				p("This column shows the projected pension value under 2020 valuation scenario 1"),
# 				p("It eliminates the DB proportion (essentially setting it to 0), so the entire pension comes from the DC pension with employee contributions of 9.6% and employer contributions of 1.8%")
# 			)),
# 			fluidRow(valueBoxOutput("scenario1_pot", width=12)),
# 			fluidRow(valueBoxOutput("scenario1_pot_perc", width=12)),
# 			fluidRow(valueBoxOutput("scenario1_pot_diff", width=12))
# 		),
# 		column(width=2,
# 			fluidRow(box(title="Proposed scenario 2a", width=12, collapsible = TRUE, collapsed = TRUE,
# 				p("This column shows the projected pension value under 2020 valuation scenario 2a"),
# 				p("It applies DB pension with accrual rate of 1/170, and a DC pension after salary reaches £40,000 towards which employees contribute 12% and employees contribute 0%.")
# 			)),
# 			fluidRow(valueBoxOutput("scenario2a_pot", width=12)),
# 			fluidRow(valueBoxOutput("scenario2a_pot_perc", width=12)),
# 			fluidRow(valueBoxOutput("scenario2a_pot_diff", width=12))
# 		),
# 		column(width=2,
# 			fluidRow(box(title="Proposed scenario 2b", width=12, collapsible = TRUE, collapsed = TRUE,
# 				p("This column shows the projected pension value under 2020 valuation scenario 2b"),
# 				p("It applies DB pension with accrual rate of 1/165, and a DC pension after salary reaches £30,000 towards which employees contribute 12% and employees contribute 0%.")
# 			)),
# 			fluidRow(valueBoxOutput("scenario2b_pot", width=12)),
# 			fluidRow(valueBoxOutput("scenario2b_pot_perc", width=12)),
# 			fluidRow(valueBoxOutput("scenario2b_pot_diff", width=12))
# 		),
# 		column(width=2,
# 			fluidRow(box(title="Proposed scenario 3a", width=12, collapsible = TRUE, collapsed = TRUE,
# 				p("This column shows the projected pension value under 2020 valuation scenario 3a"),
# 				p("It applies DB pension with accrual rate of 1/115, and a DC pension after salary reaches £40,000 towards which employees contribute 16% and employees contribute 0%.")
# 			)),
# 			fluidRow(valueBoxOutput("scenario3a_pot", width=12)),
# 			fluidRow(valueBoxOutput("scenario3a_pot_perc", width=12)),
# 			fluidRow(valueBoxOutput("scenario3a_pot_diff", width=12))
# 		),
# 		column(width=2,
# 			fluidRow(box(title="Proposed scenario 3b", width=12, collapsible = TRUE, collapsed = TRUE,
# 				p("This column shows the projected pension value under 2020 valuation scenario 3b"),
# 				p("It applies DB pension with accrual rate of 1/110, and a DC pension after salary reaches £30,000 towards which employees contribute 16% and employees contribute 0%.")
# 			)),
# 			fluidRow(valueBoxOutput("scenario3b_pot", width=12)),
# 			fluidRow(valueBoxOutput("scenario3b_pot_perc", width=12)),
# 			fluidRow(valueBoxOutput("scenario3b_pot_diff", width=12))
# 		)				
# 	)
# }

model_2020d_uss <- function()
{
	fluidRow(
		valueBoxOutput("contributions_employee_uss", width=3),
		valueBoxOutput("contributions_employer_uss", width=3),
		valueBoxOutput("contributions_total_uss", width=3)
	)
}

model_2020d_uuk <- function()
{
	fluidRow(
		valueBoxOutput("contributions_employee_uuk", width=3),
		valueBoxOutput("contributions_employer_uuk", width=3),
		valueBoxOutput("contributions_total_uuk", width=3)
	)
}

model_2020_plot <- function()
{	
	fluidRow(
		plotlyOutput("plot_total_pot") %>%
			withSpinner()
	)
}

model_2020_details <- function()
{
fluidRow(
	box(title="Background", width=12,
		p("Most assumptions for these projections are taken from the ", tags$a("USS 2020 valuation document", href=" https://www.uss.co.uk/-/media/project/ussmainsite/files/about-us/valuations_yearly/2020-valuation/uss-technical-provisions-consultation-2020-valuation.pdf?rev=89e3e8d0fbb344bf8d9609f6d0eb412e&hash=484A87C8F8D8719BF0AA864D7CC1A3D4"), "."),
		p("All figures are in real terms - i.e. after inflation."),
		p("The modeller only models the pensions we will accrue in future - pensions already accrued will not be changed."),
		p("Further details about the assumptions are provided on the tabs below."),
		p("See the about page for links to the source code, and how to get in contact with us. Let us know if this modeller can be improved in any way."),
		p("The modeller assumes that you will buy an annuity at retirement with your DC pot and that the DB pension is bought using an annuity."),
		p("Salary changes take into account increments and cost of living awards."),
		p("This modeller provides a forecast of the pensions we can expect to receive under the current defined benefit defined contribution hybrid scheme and the UUK proposed defined contribution scheme. I am not an actuary, accountant or a financial advisor. This is for information only and should not be used for personal financial decisions. Before making any decisions about your pension you should seek professional advice.")
	),
	box(title="Investment returns", width=12,
		p("USS outlined their projected investment returns in the 2020 valuation document. They project in scenario 1 a 0% investment return per year. Scenario 2a and 2b assumes 0.1% investment returns per year. Scenario 3a and 3b assumes 0.2% investment returns per year.")
	),
	box(title="Life expectancy", width=12,
		p("The model assumes that if life expectancy increases by 0.5% a year the cost of purchasing a given amount of pension income increases by 0.5% a year."),
		p("The USS valuation documents assume a 1.6% and 1.8% improvements for women and men in mortality per year based on Continuous Mortality Investigation."),
		p("This model uses an estimate of change in life expectancy at age 65 from the ONS: https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/lifeexpectancies/datasets/expectationoflifeprincipalprojectionunitedkingdom")
	),
	box(title="Inflation Assumptions", width=12,
	    p("Inflation is estimated in the modeller by randomly drawing estimates from the distribution of ", tags$a("observed inflation rates", href=" https://https://www.ons.gov.uk/economy/inflationandpriceindices/datasets/consumerpriceindices"), "after the inflation cap implemented in 1996. Forecasted rates from this distribution are capped at 2.5%."),
	    p("Options to vary this are presented, which include: Altering the cap on inflation to 5%, altering the assumption that post-96 inflation rates are more likely to be observed than rates between 1947 and 1996. Full details of the calculations can be found ", tags$a("here.", href="https://github.com/explodecomputer/USSpensions/blob/master/misc/get_cpi.r")
	    )
	),
	box(title="Differences by gender", width=12,
		p("Insurance companies cannot discriminate against individuals because of gender. The differences in annuity rates between men and women is driven by the age of spouse. We assume the male spouse is 3 years older. The annuity assumptions can be changed on the annuity tab.")
	)
)
}

dashboard2020_tab <- function()
{
	tabItem(tabName = "dashboard2020", fluidRow(
		inputs2020(),
		column(width=9,
			fluidRow(
				tabBox(width=12,
				       tabPanel("UUK Proposals",
				                model_2020_uuk()
				       ),
				      	# tabPanel("USS Proposals",
				      	# 		model_2020_uss()
				      	# ),
					# tabPanel("Projections",
					# 	model_2020()
					# ),
					tabPanel("Details",
						model_2020_details()
					)
				)
			)
		)
	))
}


dashboard2018_tab <- function()
{
	tabItem(tabName = "dashboard2018", fluidRow(
		inputs2018(),
		column(width=9,
			fluidRow(tabBox(width=12,
				tabPanel("Projections",
					model_2018a(),
					tags$hr(),
					model_2018b(),
					tags$hr(),
					model_2018c(),
					tags$hr(),
					model_2018d()
				),
				tabPanel("Details",
					model_2018_details()
				)
			))
		)
	))
}


about_tab <- function()
{
	tabItem(tabName = "about",
		column(width=6,
			fluidRow(box(width=12,
				title="About",
				p("The USS pension scheme has proposed a number of changes over the past several years."),
				p("This app provides some projections that shows the likely impact on future performance for these different models."),
				p(strong("Pension values that have already accumulated are not going to be affected")),
				p(strong("Only future pension benefits will be affected. This modeller only shows the impact on future earnings"))
			)),
			fluidRow(box(width=12,
				title="Disclaimer",
				p("This modeller provides a forecast of the pensions we can expect to receive under the current defined benefit scheme and the UUK proposed defined contribution scheme. We are not actuaries, accountants or financial advisors. This is for information only and should not be used for personal financial decisions. Before making any decisions about your pension you should seek professional advice.")
			)),
			fluidRow(box(width=12,
				title="Other models and resources",
				p("You can find professional projections elsewhere, e.g. ", tags$a("one generated by Aon", href="https://www.employerspensionsforum.co.uk/sites/default/files/uploads/aon-hewitt-modelling-proposed-uss-benefit-changes.pdf"), " and ", tags$a("one generated by First Actuarial", href="https://www.ucu.org.uk/media/8916/TPS--USS-no-DB-comparison-First-Actuarial-29-Nov-17/pdf/firstacturial_ussvtps_nodb_29nov17.pdf"), "."),
				p("Gábor Csányi has also produced a web application, which you can find ", tags$a("here", href="http://www2.eng.cam.ac.uk/~gc121/pension.html"), ".")
			))
		),
		column(width=6,
			fluidRow(box(width=12,title="Contact",
				p("Model and website developed by Neil Davies", tags$a("neil.davies@bristol.ac.uk", href="mailto:neil.davies@bristol.ac.uk"), ", Gibran Hemani", tags$a("g.hemani@bristol.ac.uk", href="mailto:g.hemani@bristol.ac.uk"), " and Gareth Griffith", tags$a("g.griffith@bristol.ac.uk", href="mailto:g.griffith@bristol.ac.uk")),
				p("We are not in any way affiliated with the USS."),
				p("This model is provisional and we will try to update it as more information comes in and when we can."),
				p("Please let us know if this modeller can be improved in any way."),
				p("Thanks to many who have provided advice, support and feedback. Thanks to Dr Justin Ales for contributing code to calculate effective loss of earnings.")
			)),
			fluidRow(box(width=12,title="Source code",
				p("All code is open source under the GPL-3 license, and can be found here:"),
				p(tags$a("github.com/explodecomputer/USSpensions", href="https://github.com/explodecomputer/USSpensions")),
				p(tags$a("github.com/explodecomputer/USSpensions-shiny", href="https://github.com/explodecomputer/USSpensions-shiny"))
			))
		)
	)
}




changelog_tab <- function()
{
	tabItem(tabName="changelog",
		fluidRow(box(width=12, title="14th May 2021",
			p("Added inflation assumptions, and replaced previous USS proposals with more recent UUK proposals")
		)),
		fluidRow(box(width=12, title="21st Apr 2021",
			p("Updated 2020 valuation model - previously we were just estimating the change in contributions, but now we are projecting the pensions as in the 2018 model")
		)),
		fluidRow(box(width=12, title="22nd Dec 2020",
			p("Added new model to calculate contributions based on 2020 valuations")
		)),
		fluidRow(box(width=12, title="23rd Mar 2018",			
			p("Thanks to Dr Alice Thompson for pointing out that 0.35% of employee contributions go towards death in service cover."),
			p("Thanks to Dr Justin Ales for contributing the projections of effective loss in income."), 
			p("Thanks to Prof Rob Anderson for pointing out further modelling considerations around changes in life expectancy.")
		)),		
		fluidRow(box(width=12, title="12th Mar 2018",			
			p("The projections for the proposal from the first UUK+UCU negotiations. Note that a major component was change to CPI but this has not been modelled.")
		)),
		fluidRow(box(width=12, title="24th Feb 2018",			
			p("Thank you for all your feedback. We have amended the default value for annual increase in life expectancy from 1.5% to 0.5% as of 24/2/2018 and changed the default investment scheme to USS 67")
		)),
		fluidRow(box(width=12, title="13th Feb 2018",			
			p("First release.")
		))
	)
}


dashboardPage(
	dashboardHeader(title = "USS pensions calculator"),
	dashboardSidebar(
		sidebarMenu(
			menuItem("2020 USS valuation", tabName="dashboard2020", icon=icon("dashboard")),
			menuItem("2018 USS valuation", tabName="dashboard2018", icon=icon("dashboard")),
			menuItem("About", tabName = "about", icon=icon("info")),
			menuItem("Change log", tabName = "changelog", icon=icon("cogs"))
		)
	),
	dashboardBody(
		tags$head(
			includeScript("https://www.googletagmanager.com/gtag/js?id=UA-53610054-2"),
			includeScript("google-analytics.js")
		),
		tabItems(
			dashboard2020_tab(),
			dashboard2018_tab(),
			about_tab(),
			changelog_tab()
		)
	)
)


