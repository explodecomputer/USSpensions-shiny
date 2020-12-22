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
			fluidRow(valueBoxOutput("db_income", width=12))
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




dashboard_tab <- function()
{
	tabItem(tabName = "dashboard", fluidRow(
		column(width=5,
			fluidRow(box(width=12,
				p("This is a simple web app that estimates the impacts of the various proposed changes to the USS pension scheme."),
				p("Version: ",
				strong(paste0(paste(scan("version.txt", what=character()), collapse=" "), " (", format(as.Date(file.info("version.txt")$mtime,), "Last update: %d %B %Y"), ")")))
			)),
			fluidRow(box(title="Your details", width=12,
				column(width=4,
					numericInput("input_income", "Income (£):", 35000, min=0, max=1000000)
				),
				column(width=4,
					dateInput("input_dob", "Date of birth:", value="1984-09-06")
				),
				column(width=2,
					radioButtons("input_sex", "Sex:", c("Female"="women", "Male"="men"))
				),
				column(width=2,
					radioButtons("input_spouse", "Spouse:", c("No"="single", "Yes"="joint"))
				)
			)),
			fluidRow(box(title="Technical assumptions (see About page)", width=12,
				fluidRow(
					column(width=6,
						numericInput("input_payinc", "Annual % change in pay (after CPI)", 2, min=0, max=100)
					),
					column(width=6,
						numericInput("input_lei", "% Increase in life expectancy / year", 0.5, min=-100, max=100))
				)
			)),
			fluidRow(box(title="Contributions to DC pension (see About page)", width=12,
				fluidRow(
					column(width=6,
						numericInput("input_employeecont", "Employee contribution (%)", 7.65, min=0, max=100)
					),
					column(width=6,
						numericInput("input_employercont", "Employer contribution (%)", 12, min=0, max=100)
					)
				)
			)),
			fluidRow(box(title="Investment assumptions", width=12,
				fluidRow(
					column(width=6,
						radioButtons("input_invscheme", "Assumed investment scheme", c("USS", "Growth fund", "Moderate growth fund", "Cautious growth fund", "Cash fund"))
					),
					column(width=6,
						radioButtons("input_invprudence", "Investment prudence", c(67, 50))
					)
				)
			))
		),
		column(width=7,

			# Retirement year
			fluidRow(
				valueBoxOutput("retirement_year", width=12)
			),
			fluidRow(tabBox(width=12,
				tabPanel("2020 model",
					p("The latest round of proposed changes concern the employee and employer pension contributions. The proposal is for employees and employers to considerably increase contributions, but this will be for the same final benefit (i.e. the employee will pay more of their salary over the course of their employment for the same amount of return)."),
					p("The plot here shows the amount that you will contribute to your pension over the remainder of your working life under the 2017 plan (No change), the current plan, and the proposed plans (minimum and maximum)."),
					plotlyOutput("cont_plot")
				),
				tabPanel("2018 model",
					p("This model was first created to understand the USS's 2018 valuation. It forecasts the benefits that you will accrue under three different schemes:"),
					p(tags$ul(
						tags$li("What you would get if the scheme remained unchanged (Defined benefits, DB)"),
						tags$li("What USS is proposing (Defined contribution, DC)"),
						tags$li("What the Teachers Pension Scheme provides (TPS) for comparison")
					)),
					p(strong("Note:"), "This is for future benefits only. The proposed changes will not impact benefits that have already been accrued, and this has not been modelled. This is an independent web app. It is not in any way affiliated with USS."),
					model_2018a(),
					tags$hr(),
					model_2018b(),
					tags$hr(),
					model_2018c(),
					tags$hr(),
					model_2018d()
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
				p("The USS pension scheme has proposed a change from the defined benefits (DB) model to the defined contributions (DC) model."),
				p("This app provides some projections that shows the likely impact on future performance for these different models. It also provides the results for the Post 92 Teacher Pension Scheme (TPS) for comparison."),
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
			)),
			fluidRow(box(width=12,title="Contact",
				p("Model and website developed by Neil Davies", tags$a("neil.davies@bristol.ac.uk", href="mailto:neil.davies@bristol.ac.uk"), " and Gibran Hemani", tags$a("g.hemani@bristol.ac.uk", href="mailto:g.hemani@bristol.ac.uk")),
				p("We are not in any way affiliated with the USS."),
				p("This model is provisional and we will try to update it as more information comes in and when we can."),
				p("Please let us know if this modeller can be improved in any way."),
				p("Thanks to many who have provided advice, support and feedback. Thanks to Dr Justin Ales for contributing code to calculate effective loss of earnings.")
			)),
			fluidRow(box(width=12,title="Source code",
				p("All code is open source under the GPL-3 license, and can be found here:"),
				p(tags$a("github.com/explodecomputer/USSpensions", href="https://github.com/explodecomputer/USSpensions")),
				p(tags$a("github.com/explodecomputer/USSpensions-shiny", href="https://github.com/explodecomputer/USSpensions-shiny")),
				p("The calculations are based on the values in the spreadsheet found ", tags$a("here", href="https://www.dropbox.com/s/ld9hqka4hm5ncfl/modeller_nmd_180313.xlsx?dl=0"))
			))
		),
		column(width=6,
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
			))
		)
	)
}




changelog_tab <- function()
{
	tabItem(tabName="changelog",
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
			menuItem("Dashboard", tabName="dashboard", icon=icon("dashboard")),
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
			dashboard_tab(),
			about_tab(),
			changelog_tab()
		)
	)
)


