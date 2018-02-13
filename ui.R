library(shinydashboard)



dashboard_tab <- function()
{
	tabItem(tabName = "dashboard", fluidRow(
		column(width=5,
			fluidRow(box(title="Your details", width=12,
				column(width=4,
					numericInput("input_income", "Income (£):", 43600, min=0, max=1000000)
				),
				column(width=4,
					dateInput("input_dob", "Date of birth:", value="1984-09-06")
				),
				column(width=2,
					radioButtons("input_sex", "Sex:", c("Male"="men", "Female"="women"))
				),
				column(width=2,
					radioButtons("input_spouse", "Spouse:", c("Yes"="joint", "No"="single"))
				)
			)),
			fluidRow(box(title="Technical assumptions", width=12,
				fluidRow(
					column(width=6,
						numericInput("input_payinc", "Annual % change in pay (after CPI)", 2, min=0, max=100),
						numericInput("input_maxpay", "Maximum salary", 55000, min=0, max=Inf)
					),
					column(width=6,
						numericInput("input_lei", "% Increase in life expectancy / year", 1.5, min=0, max=100))
				)
			)),
			fluidRow(box(title="Contributions", width=12,
				fluidRow(
					column(width=6,
						numericInput("input_employeecont", "Employee contribution (%)", 8.00, min=0, max=100)
					),
					column(width=6,
						numericInput("input_employercont", "Employer contribution (%)", 13.25, min=0, max=100)
					)
				)
			)),
			fluidRow(box(title="Investment assumptions", width=12,
				fluidRow(
					column(width=6,
						radioButtons("input_invscheme", "Assumed investment scheme", c("USS", "Growth fund", "Moderate growth fund", "Cautious growth fund", "Cash fund"))
					),
					column(width=6,
						radioButtons("input_invprudence", "Investment prudence", c(50, 67))
					)
				)
			))
		),
		column(width=7,

			# Retirement year
			fluidRow(
				valueBoxOutput("retirement_year", width=12)
			),
			tags$hr(),
			fluidRow(
				column(width=4,
					fluidRow(valueBoxOutput("dc_income", width=12))
				),
				column(width=4,
					fluidRow(valueBoxOutput("db_income", width=12)),
					fluidRow(valueBoxOutput("db_income_perc", width=12))
				),
				column(width=4,
					fluidRow(valueBoxOutput("tps_income", width=12)),
					fluidRow(valueBoxOutput("tps_income_perc", width=12))
				)				
			),
			tags$hr(),
			fluidRow(
				column(width=4,
					fluidRow(valueBoxOutput("dc_pot", width=12))
				),
				column(width=4,
					fluidRow(valueBoxOutput("db_pot", width=12)),
					fluidRow(valueBoxOutput("db_pot_perc", width=12))
				),
				column(width=4,
					fluidRow(valueBoxOutput("tps_pot", width=12)),
					fluidRow(valueBoxOutput("tps_pot_perc", width=12))
				)
			)
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
				p("This app provides some projections that shows the likely impact on future performance for these different models. It also provides the results for the Post 92 Teacher Pension Scheme for comparison.")
			)),
			fluidRow(box(width=12,
				title="Disclaimer",
				p("This modeller provides a forecast of the pensions we can expect to receive under the current defined benefit scheme and the UUK proposed defined contribution scheme. I am not an actuary, accountant or a financial advisor. This is for information only and should not be used for personal financial decisions. Before making any decisions about your pension you should seek professional advice.")
			)),
			fluidRow(box(width=12,title="Contact",
				p("Model developed by Neil Davies", tags$a("neil.davies@bristol.ac.uk", href="mailto:neil.davies@bristol.ac.uk")),
				p("Let me know if this modeller can be improved in any way."),
				p("All code is open source under the GPL-3 license, and can be found here:"),
				p(tags$a("github.com/explodecomputer/USSpensions", href="https://github.com/explodecomputer/USSpensions")),
				p(tags$a("github.com/explodecomputer/USSpensions-shiny", href="https://github.com/explodecomputer/USSpensions-shiny"))

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

			fluidRow(box(width=12,title="Life expectancy",

				p("The assumptions on life expectancy are taken from the USS valuation documents."),
				p("The model assumes that if life expectancy increases by 1% the cost of purchasing a given amount of pension income increases by 1%.")
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

dashboardPage(
	dashboardHeader(title = "USS pensions calculator"),
	dashboardSidebar(
		sidebarMenu(
			menuItem("Dashboard", tabName="dashboard", icon=icon("dashboard")),
			menuItem("About", tabName = "about", icon=icon("info"))
		)
	),
	dashboardBody(
		tabItems(
			dashboard_tab(),
			about_tab()
		)
	)
)


