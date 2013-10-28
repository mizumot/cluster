

library(shiny)

shinyUI(bootstrapPage(

    headerPanel("Cluster Analysis"),

    mainPanel(
        tabsetPanel(

        tabPanel("Main",

            strong('Option:'),

            checkboxInput("colname", label = strong("Check if the data includes variable names in the 1st row."), value = T),

            br(),

            p('Note: Input values must be separated by tabs. Copy and paste from Excel/Numbers.'),

            aceEditor("text", value="TOEIC\tOral_Rehearsal\tAssociation\tExtrinsic_Motivation\tIntrinsic_Motivation\tTime\n390\t2.7\t3.7\t3.33\t3.17\t6.92\n360\t4.3\t3\t3.33\t3.17\t5.83\n410\t2\t2\t2.67\t2.5\t2.36\n390\t3.3\t2.7\t4.67\t4.83\t4.36\n365\t3.7\t1\t3.67\t4.5\t3.78\n415\t4.3\t2.7\t4.33\t3.5\t6.55\n415\t3\t2.7\t4\t2.67\t4.56\n340\t2.7\t1.7\t4.33\t2.83\t4\n370\t3.3\t3\t4.33\t3.67\t4.73\n360\t1.3\t1.7\t4.33\t2.5\t4.5\n410\t3.3\t2.7\t4\t4.17\t8.3\n430\t4\t2\t4\t4\t8.58\n340\t3.3\t3.3\t3.67\t3.67\t4.9\n305\t3.7\t2.3\t3.33\t3.83\t7\n380\t1.7\t2.3\t4\t4\t6.92\n390\t3.7\t1\t3.67\t3.33\t5.18\n300\t2.7\t1.7\t3\t2.5\t3.73\n370\t3\t3.7\t3.33\t1.83\t6.2\n315\t2\t2\t2.67\t2.67\t3.22\n370\t3.3\t2.3\t4\t4.17\t4\n315\t2.7\t3.3\t3\t3.33\t2.75\n385\t3\t2.7\t4\t2.83\t7.25\n405\t4\t3.3\t4.33\t3.17\t2.56\n380\t5\t1.7\t5\t4.17\t5.6\n355\t1.3\t2.3\t4.33\t4.83\t6.36\n310\t1\t2.3\t4.67\t2.83\t3.18\n345\t5\t4.3\t3.67\t2.5\t5\n390\t3.3\t4\t5\t5\t4.83\n340\t1\t1.7\t4.67\t3.33\t5.75\n365\t1.3\t2\t3.33\t3.17\t6.42",
                mode="r", theme="solarized_light"),

            br(),

            h3("Basic statistics"),
            verbatimTextOutput("textarea.out"),

            br(),

            h3("Correlation"),

            radioButtons("method", "Check the type of correlation coefficients:",
                        list("Pearson product-moment correlation coefficient" = "Pearson",
                             "Spearman's rank correlation coefficient (Spearman's rho)" = "Spearman",
                             "Kendall tau rank correlation coefficient (Kendall's tau)" = "Kendall")),

            verbatimTextOutput("correl.out"),

            br(),

            strong("Scatter plot matrices"),
            plotOutput("corPlot"),

            br(),


            h3("Cluster analysis"),

            strong('Option:'),

            checkboxInput("stdz", label = strong("Check if standardized scores will be used for analysis."), value = T),

            verbatimTextOutput("clustermethod.out"),

            plotOutput("clusterPlot"),

            p(br())

            ),


        tabPanel("About",

            strong('Note'),
            p('This web application is developed with',
            a("Shiny.", href="http://www.rstudio.com/shiny/", target="_blank"),
            ''),

            br(),

            strong('Code'),
            p('Source code for this application is based on',
            a('"The handbook of Research in Foreign Language Learning and Teaching" (Takeuchi & Mizumoto, 2012).', href='http://mizumot.com/handbook/', target="_blank")),

            p('The code for this web application is available at',
            a('GitHub.', href='https://github.com/mizumot/cluster', target="_blank")),

            p('If you want to run this code on your computer (in a local R session), run the code below:',
            br(),
            code('library(shiny)'),br(),
            code('runGitHub("cluster","mizumot")')
            ),

            br(),

            strong('Recommended'),
            p('To learn more about R, I suggest this excellent and free e-book (pdf),',
            a("A Guide to Doing Statistics in Second Language Research Using R,", href="http://cw.routledge.com/textbooks/9780805861853/guide-to-R.asp", target="_blank"),
            'written by Dr. Jenifer Larson-Hall.'),

            p('Also, if you are a cool Mac user and want to use R with GUI,',
            a("MacR", href="http://www.urano-ken.com/blog/2013/02/25/installing-and-using-macr/", target="_blank"),
            'is defenitely the way to go!'),

            br(),

            strong('Author'),
            p(a("Atsushi MIZUMOTO,", href="http://mizumot.com", target="_blank"),' Ph.D.',br(),
            'Associate Professor of Applied Linguistics',br(),
            'Faculty of Foreign Language Studies /',br(),
            'Graduate School of Foreign Language Education and Research,',br(),
            'Kansai University, Osaka, Japan'),

            br(),

            a(img(src="http://i.creativecommons.org/p/mark/1.0/80x15.png"), target="_blank", href="http://creativecommons.org/publicdomain/mark/1.0/"),

            p(br())

            )

))
))
